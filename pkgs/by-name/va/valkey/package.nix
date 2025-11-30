{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  lua,
  jemalloc,
  pkg-config,
  nixosTests,
  tcl,
  which,
  ps,
  getconf,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
  # dependency ordering is broken at the moment when building with openssl
  tlsSupport ? !stdenv.hostPlatform.isStatic,
  openssl,

  # Using system jemalloc fixes cross-compilation and various setups.
  # However the experimental 'active defragmentation' feature of valkey requires
  # their custom patched version of jemalloc.
  useSystemJemalloc ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "valkey";
  version = "8.1.4";

  src = fetchFromGitHub {
    owner = "valkey-io";
    repo = "valkey";
    rev = finalAttrs.version;
    hash = "sha256-obtmiDobMs/POqYH5XjqpzmjVrEC6gUsTc1rREDJ8tw=";
  };

  patches = lib.optional useSystemJemalloc ./use_system_jemalloc.patch;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    lua
  ]
  ++ lib.optional useSystemJemalloc jemalloc
  ++ lib.optional withSystemd systemd
  ++ lib.optional tlsSupport openssl;

  strictDeps = true;

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/Makefile --replace-fail "-flto" ""
  '';

  # More cross-compiling fixes.
  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "AR=${stdenv.cc.targetPrefix}ar"
    "RANLIB=${stdenv.cc.targetPrefix}ranlib"
  ]
  ++ lib.optionals withSystemd [ "USE_SYSTEMD=yes" ]
  ++ lib.optionals tlsSupport [ "BUILD_TLS=yes" ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isClang [ "-std=c11" ]);

  # darwin currently lacks a pure `pgrep` which is extensively used here
  doCheck = !stdenv.hostPlatform.isDarwin;
  nativeCheckInputs = [
    which
    tcl
    ps
  ]
  ++ lib.optionals stdenv.hostPlatform.isStatic [ getconf ];
  checkPhase = ''
    runHook preCheck

    # disable test "Connect multiple replicas at the same time": even
    # upstream find this test too timing-sensitive
    substituteInPlace tests/integration/replication.tcl \
      --replace-fail 'foreach mdl {no yes} dualchannel {no yes}' 'foreach mdl {} dualchannel {}'

    substituteInPlace tests/support/server.tcl \
      --replace-fail 'exec /usr/bin/env' 'exec env'

    sed -i '/^proc wait_load_handlers_disconnected/{n ; s/wait_for_condition 50 100/wait_for_condition 50 500/; }' \
      tests/support/util.tcl

    CLIENTS="$NIX_BUILD_CORES"
    if (( $CLIENTS > 4)); then
      CLIENTS=4
    fi

    # Skip some more flaky tests.
    # Skip test requiring custom jemalloc (unit/memefficiency).
    ./runtest \
      --no-latency \
      --timeout 2000 \
      --clients "$CLIENTS" \
      --tags -leaks \
      --skipunit unit/memefficiency \
      --skipunit integration/failover \
      --skipunit integration/aof-multi-part

    runHook postCheck
  '';

  passthru = {
    tests.redis = nixosTests.redis;
    serverBin = "valkey-server";
  };

  meta = with lib; {
    homepage = "https://valkey.io/";
    description = "High-performance data structure server that primarily serves key/value workloads";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ ];
    changelog = "https://github.com/valkey-io/valkey/releases/tag/${finalAttrs.version}";
    mainProgram = "valkey-cli";
  };
})
