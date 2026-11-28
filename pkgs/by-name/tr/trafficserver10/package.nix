{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
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
  # cjose is only used by the uri_signing plugin, which needs glibc's
  # hsearch_r and re_compile_pattern (it fails to build on Darwin)
  withCjose ? stdenv.hostPlatform.libc == "glibc",
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
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trafficserver10";
  version = "10.2.1";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "trafficserver";
    tag = finalAttrs.version;
    hash = "sha256-6hi6siEmktmcT8DEoa38d2A6Qljzaz80x9kALvPIswU=";
  };

  patches = [
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
  ++ lib.optionals withBrotli [ brotli ]
  ++ lib.optionals withCap [ libcap ]
  ++ lib.optionals withCjose [ cjose ]
  ++ lib.optionals withCurl [ curl ]
  ++ lib.optionals withHiredis [ hiredis ]
  ++ lib.optionals withHwloc [ hwloc ]
  ++ lib.optionals withImageMagick [ imagemagick ]
  ++ lib.optionals withJansson [ jansson ]
  ++ lib.optionals withKyotoCabinet [ kyotocabinet ]
  ++ lib.optionals withCurses [ ncurses ]
  ++ lib.optionals withLuaJIT [ luajit ]
  ++ lib.optionals withUnwind [ libunwind ]
  ++ lib.optionals withMaxmindDB [ libmaxminddb ];

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

  # Tests require network access and a running server
  doCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  enableParallelBuilding = true;
  strictDeps = true;
  __structuredAttrs = true;

  passthru.tests.traffic-via = runCommand "trafficserver10-traffic-via" { } ''
    # Verify traffic_via parses Via headers correctly
    output=$(${lib.getExe' finalAttrs.finalPackage "traffic_via"} '[uScMsEf p eC:t cCMp sF]')
    echo "$output" | grep -q "Via header is"
    echo "$output" | grep -q "Length is 22"
    echo "$output" | grep -q "cache miss"
    touch $out
  '';

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
    mainProgram = "traffic_server";
    platforms = lib.platforms.unix;
  };
})
