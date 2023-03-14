{ lib
, stdenv
, fetchurl
, darwin
, openssl

# major and only downstream dependency
, vlc
}:

stdenv.mkDerivation rec {
  pname = "live555";
  version = "2023.01.19";

  src = fetchurl {
    urls = [
      "http://www.live555.com/liveMedia/public/live.${version}.tar.gz"
      "https://download.videolan.org/contrib/live555/live.${version}.tar.gz"
      "mirror://sourceforge/slackbuildsdirectlinks/live.${version}.tar.gz"
    ];
    sha256 = "sha256-p8ZJE/f3AHxf3CnqgR48p4HyYicbPkKv3UvBBB2G+pk=";
  };

  nativeBuildInputs = lib.optional stdenv.isDarwin darwin.cctools;

  buildInputs = [ openssl ];

  postPatch = ''
    substituteInPlace config.macosx-catalina \
      --replace '/usr/lib/libssl.46.dylib' "${lib.getLib openssl}/lib/libssl.dylib" \
      --replace '/usr/lib/libcrypto.44.dylib' "${lib.getLib openssl}/lib/libcrypto.dylib"
    sed -i -e 's|/bin/rm|rm|g' genMakefiles
    sed -i \
      -e 's/$(INCLUDES) -I. -O2 -DSOCKLEN_T/$(INCLUDES) -I. -O2 -I. -fPIC -DRTSPCLIENT_SYNCHRONOUS_INTERFACE=1 -DSOCKLEN_T/g' \
      config.linux
  '' # condition from icu/base.nix
    + lib.optionalString (stdenv.hostPlatform.libc == "glibc" || stdenv.hostPlatform.libc == "musl") ''
    substituteInPlace liveMedia/include/Locale.hh \
      --replace '<xlocale.h>' '<locale.h>'
  '';

  configurePhase = ''
    runHook preConfigure

    ./genMakefiles ${
      if stdenv.isLinux then
        "linux"
      else if stdenv.isDarwin then
        "macosx-catalina"
      else
        throw "Unsupported platform ${stdenv.hostPlatform.system}"}

    runHook postConfigure
  '';

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  enableParallelBuilding = true;

  passthru.tests = {
    inherit vlc;
  };

  meta = with lib; {
    homepage = "http://www.live555.com/liveMedia/";
    description = "Set of C++ libraries for multimedia streaming, using open standard protocols (RTP/RTCP, RTSP, SIP)";
    changelog = "http://www.live555.com/liveMedia/public/changelog.txt";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
