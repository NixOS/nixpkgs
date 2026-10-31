{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
  pkg-config,
  linuxHeaders,
  openssl,
  pcre2,
  python3,
  yaml-cpp,
  zlib,
  withHwloc ? true,
  hwloc,
  withCurl ? true,
  curl,
  withCurses ? true,
  ncurses,
  withCap ? stdenv.hostPlatform.isLinux,
  libcap,
  withUnwind ? stdenv.hostPlatform.isLinux,
  libunwind,
  # optional dependencies (everything enabled except for libmaxminddb)
  withBrotli ? true,
  brotli,
  withCjose ? true,
  cjose,
  withHiredis ? true,
  hiredis,
  withImageMagick ? true,
  imagemagick,
  withJansson ? true,
  jansson,
  withKyotoCabinet ? true,
  kyotocabinet,
  # LuaJIT has no upstream support on some platforms (e.g. riscv64), so enable it
  # only where it is actually available; otherwise the package fails to evaluate.
  withLuaJIT ? lib.meta.availableOn stdenv.hostPlatform luajit,
  luajit,
  withMaxmindDB ? false,
  libmaxminddb,
  # optional features
  enableWCCP ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trafficserver10";
  version = "10.2.0";

  # 10.2.x drops the legacy PCRE1 dependency and links only PCRE2.
  src = fetchFromGitHub {
    owner = "apache";
    repo = "trafficserver";
    tag = finalAttrs.version;
    hash = "sha256-xhmGvycf9KcNSOV9mR/zf2FsVJiAZ5Np4AftcIEamjc=";
  };

  patches = [
    # Fall back to the __atomic builtins (libatomic) for the freelist's 128-bit
    # CAS on targets with no inline one, such as riscv64, which otherwise hit
    # `#error "unsupported processor"`. x86_64 and aarch64 keep the inline CAS.
    # Backported to the 10.2.x branch, so drop this once 10.2.1 is released.
    (fetchpatch {
      name = "freelist-128bit-cas-atomic-fallback.patch";
      url = "https://github.com/apache/trafficserver/commit/56b1e10d8513f783ac39fff55e527690ea0fc16c.patch";
      hash = "sha256-mT8vAT0yJSVSVfYkLb5TWoGjN4S8RmsA8DN10Yi2kSw=";
    })
    # The thread stack guard hard-codes a list of architectures whose stack grows
    # down; riscv64 is missing from it, although its stack grows down as well.
    ./riscv-stack-growth-direction.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ linuxHeaders ];

  buildInputs = [
    openssl
    pcre2
    yaml-cpp
    zlib
  ]
  ++ lib.optional withBrotli brotli
  ++ lib.optional withCap libcap
  ++ lib.optional withCjose cjose
  ++ lib.optional withCurl curl
  ++ lib.optional withHiredis hiredis
  ++ lib.optional withHwloc hwloc
  ++ lib.optional withImageMagick imagemagick
  ++ lib.optional withJansson jansson
  ++ lib.optional withKyotoCabinet kyotocabinet
  ++ lib.optional withCurses ncurses
  ++ lib.optional withLuaJIT luajit
  ++ lib.optional withUnwind libunwind
  ++ lib.optional withMaxmindDB libmaxminddb;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_EXPERIMENTAL_PLUGINS" true)
    (lib.cmakeBool "EXTERNAL_YAML_CPP" true)
    # keep default configs and runtime state out of the build's default prefix
    (lib.cmakeFeature "CMAKE_INSTALL_SYSCONFDIR" "etc")
    (lib.cmakeFeature "CMAKE_INSTALL_LOCALSTATEDIR" "var")
    (lib.cmakeBool "ENABLE_WCCP" enableWCCP)
  ]
  # TPROXY is a Linux-only kernel feature; FORCE bypasses the /usr/include/linux/in.h check
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    (lib.cmakeFeature "ENABLE_TPROXY" "FORCE")
  ];

  postInstall = ''
    # Move default configs to share for NixOS module to use
    # The Nix store is read-only, so configs must be managed externally
    mkdir -p $out/share/trafficserver
    if [ -d "$out/etc" ]; then
      cp -r $out/etc/* $out/share/trafficserver/
      rm -rf $out/etc
    fi

    # Remove empty var directories (runtime state must be managed by NixOS module)
    rm -rf $out/var
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    # Verify traffic_via parses Via headers correctly
    output=$($out/bin/traffic_via '[uScMsEf p eC:t cCMp sF]')
    echo "$output" | grep -q "Via header is"
    echo "$output" | grep -q "Length is 22"
    echo "$output" | grep -q "cache miss"

    runHook postInstallCheck
  '';

  # Tests require network access and a running server
  doCheck = false;
  # The installCheck runs the freshly-built traffic_via, so it can only run when
  # the build platform can execute host-platform binaries (i.e. not when cross
  # compiling). This keeps cross builds from requiring emulation.
  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  enableParallelBuilding = true;
  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    homepage = "https://trafficserver.apache.org";
    changelog = "https://github.com/apache/trafficserver/releases/tag/${finalAttrs.version}";
    description = "Fast, scalable, and extensible HTTP caching proxy server";
    longDescription = ''
      Apache Traffic Server is a high-performance web proxy cache that improves
      network efficiency and performance by caching frequently-accessed
      information at the edge of the network. This brings content physically
      closer to end users, while enabling faster delivery and reduced bandwidth
      use. Traffic Server is designed to improve content delivery for
      enterprises, Internet service providers (ISPs), backbone providers, and
      large intranets by maximizing existing and available bandwidth.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ randomizedcoder ];
    platforms = lib.platforms.unix;
  };
})
