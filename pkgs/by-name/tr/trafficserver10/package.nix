# Apache Traffic Server 10.x - High-performance HTTP caching proxy
#
# Package structure:
#   $out/bin/               - Server binaries (traffic_server, traffic_ctl, etc.)
#   $out/lib/               - Shared libraries
#   $out/libexec/           - Plugins (.so files)
#   $out/include/           - Development headers
#   $out/share/trafficserver/ - Default config files
#
# Note: Config files are in share/ (not etc/) because the Nix store is read-only.
# A NixOS module should copy/symlink these to /etc/trafficserver/ and create
# runtime directories at /var/log/trafficserver/, /var/cache/trafficserver/, etc.
#
# To upgrade (e.g., 10.1.0 -> 10.2.0):
#   1. Update `version` to the new version number
#   2. Update `hash` in src (use: nix-prefetch-url --unpack <new-url> then nix hash convert)
#   3. Rebuild and test: nix-build -A trafficserver10
#   4. Verify linking: ldd result/bin/traffic_server | grep -E "(yaml|pcre|ssl)"
#
{
  lib,
  stdenv,
  fetchzip,
  cmake,
  ninja,
  pkg-config,
  linuxHeaders,
  openssl,
  # both pcre and pcre2 are required
  pcre,
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
  # optional dependencies ( everything enabled except for libmaxminddb)
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
  withLuaJIT ? true,
  luajit,
  withMaxmindDB ? false,
  libmaxminddb,
  # optional features
  enableWCCP ? true,
}:

stdenv.mkDerivation rec {
  pname = "trafficserver";
  version = "10.1.0";

  src = fetchzip {
    url = "mirror://apache/trafficserver/trafficserver-${version}.tar.bz2";
    hash = "sha256-8FQtJroMdIZvBzpT299H/5pB9+KbapZtIUvGtcuF9h4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ linuxHeaders ];

  buildInputs = [
    openssl
    pcre
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

  outputs = [ "out" ];

  cmakeFlags = [
    "-DBUILD_EXPERIMENTAL_PLUGINS=ON"
    "-DEXTERNAL_YAML_CPP=ON"
    # Ensure proper installation paths
    "-DCMAKE_INSTALL_SYSCONFDIR=etc"
    "-DCMAKE_INSTALL_LOCALSTATEDIR=var"
    (lib.cmakeBool "ENABLE_WCCP" enableWCCP)
  ]
  # TPROXY is a Linux-only kernel feature; FORCE bypasses /usr/include/linux/in.h check
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "-DENABLE_TPROXY=FORCE"
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
  doInstallCheck = true;

  meta = {
    homepage = "https://trafficserver.apache.org";
    changelog = "https://github.com/apache/trafficserver/releases/tag/${version}";
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
    # maintainers = with lib.maintainers; [ randomizedcoder ];
    # TODO: Add maintainer after https://github.com/NixOS/nixpkgs/pull/473609 is merged
    platforms = lib.platforms.unix;
  };
}
