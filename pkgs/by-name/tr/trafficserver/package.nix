{
  cmake,
  coreutils,
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  nixosTests,
  pkg-config,
  file,
  linuxHeaders,
  openssl,
  pcre,
  pcre2,
  perlPackages,
  # recommended dependencies
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
  # optional dependencies
  withBrotli ? false,
  brotli,
  withCjose ? false,
  cjose,
  withGeoIP ? false,
  geoip,
  withHiredis ? false,
  hiredis,
  withImageMagick ? false,
  imagemagick,
  withJansson ? false,
  jansson,
  withKyotoCabinet ? false,
  kyotocabinet,
  withLuaJIT ? false,
  luajit,
  withMaxmindDB ? false,
  libmaxminddb,
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
    makeWrapper
    pkg-config
    file
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ linuxHeaders ];

  buildInputs = [
    openssl
    pcre.dev
    pcre2.dev
    perlPackages.perl
  ]
  ++ lib.optional withBrotli brotli
  ++ lib.optional withCap libcap
  ++ lib.optional withCjose cjose
  ++ lib.optional withCurl curl
  ++ lib.optional withGeoIP geoip
  ++ lib.optional withHiredis hiredis
  ++ lib.optional withHwloc hwloc
  ++ lib.optional withImageMagick imagemagick
  ++ lib.optional withJansson jansson
  ++ lib.optional withKyotoCabinet kyotocabinet
  ++ lib.optional withCurses ncurses
  ++ lib.optional withLuaJIT luajit
  ++ lib.optional withUnwind libunwind
  ++ lib.optional withMaxmindDB libmaxminddb;

  patches = [
    # https://github.com/apache/trafficserver/pull/12481
    ./test-reset-root.patch
  ];

  postPatch = ''
    patchShebangs \
      src/iocore/aio/test_AIO.sample \
      src/traffic_via/test_traffic_via \
      src/traffic_logstats/tests \
      tools/check-unused-dependencies
    substituteInPlace ./rc/trafficserver.service.in \
      --replace-fail '/bin/rm' '${coreutils}/bin/rm'
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace ./cmake/ConfigureTransparentProxy.cmake \
      --replace-fail '/usr/include/linux' '${linuxHeaders}/include/linux'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # 'xcrun leaks' probably requires non-free XCode
    substituteInPlace src/iocore/net/test_certlookup.cc \
      --replace-fail 'xcrun leaks' 'true'
  '';

  cmakeFlags = [
    "-DBUILD_EXPERIMENTAL_PLUGINS=ON"
    "-DCMAKE_INSTALL_SYSCONFDIR=${placeholder "out"}/etc/trafficserver"

    # replace runtime directories with an install-time placeholder directory
    "-DCMAKE_INSTALL_CACHEDIR=${placeholder "out"}/.install-trafficserver"
    "-DCMAKE_INSTALL_LOCALSTATEDIR=${placeholder "out"}/.install-trafficserver"
    "-DCMAKE_INSTALL_LOGDIR=${placeholder "out"}/.install-trafficserver"
    "-DCMAKE_INSTALL_RUNSTATEDIR=${placeholder "out"}/.install-trafficserver"
  ];

  preCheck = ''
    export TS_ROOT=$(pwd)
  '';

  postInstall = ''
    install -Dm644 rc/trafficserver.service $out/lib/systemd/system/trafficserver.service

    find "$out" -name '*.la' -delete

    # ensure no files actually exist in this directory
    rmdir $out/.install-trafficserver
  '';

  installCheckPhase =
    let
      expected = ''
        Via header is [uScMsEf p eC:t cCMp sF], Length is 22
        Via Header Details:
        Request headers received from client                   :simple request (not conditional)
        Result of Traffic Server cache lookup for URL          :miss (a cache "MISS")
        Response information received from origin server       :error in response
        Result of document write-to-cache:                     :no cache write performed
        Proxy operation result                                 :unknown
        Error codes (if any)                                   :connection to server failed
        Tunnel info                                            :no tunneling
        Cache Type                                             :cache
        Cache Lookup Result                                    :cache miss (url not in cache)
        Parent proxy connection status                         :no parent proxy or unknown
        Origin server connection status                        :connection open failed
      '';
    in
    ''
      runHook preInstallCheck
      diff -Naur <($out/bin/traffic_via '[uScMsEf p eC:t cCMp sF]') - <<EOF
      ${lib.removeSuffix "\n" expected}
      EOF
      runHook postInstallCheck
    '';

  doCheck = true;
  doInstallCheck = true;
  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) trafficserver; };

  meta = {
    homepage = "https://trafficserver.apache.org";
    changelog = "https://raw.githubusercontent.com/apache/trafficserver/${version}/CHANGELOG-${version}";
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
    maintainers = with lib.maintainers; [ midchildan ];
    platforms = lib.platforms.unix;
  };
}
