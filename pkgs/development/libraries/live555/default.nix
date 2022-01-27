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
  version = "2022.01.21";

  src = fetchurl {
    urls = [
      "http://www.live555.com/liveMedia/public/live.${version}.tar.gz"
      "https://download.videolan.org/contrib/live555/live.${version}.tar.gz"
      "mirror://sourceforge/slackbuildsdirectlinks/live.${version}.tar.gz"
    ];
    sha256 = "sha256-diV5wULbOrqMRDCyI9NjVaR6JUbYl9KWHUlvA/jjqQ4=";
  };

  nativeBuildInputs = lib.optional stdenv.isDarwin darwin.cctools;

  buildInputs = [ openssl ];

  postPatch = ''
    substituteInPlace config.macosx-catalina \
      --replace '/usr/lib/libssl.46.dylib' "${openssl.out}/lib/libssl.dylib" \
      --replace '/usr/lib/libcrypto.44.dylib' "${openssl.out}/lib/libcrypto.dylib"
    sed -i -e 's|/bin/rm|rm|g' genMakefiles
    sed -i \
      -e 's/$(INCLUDES) -I. -O2 -DSOCKLEN_T/$(INCLUDES) -I. -O2 -I. -fPIC -DRTSPCLIENT_SYNCHRONOUS_INTERFACE=1 -DSOCKLEN_T/g' \
      config.linux
  '' + lib.optionalString (stdenv ? glibc) ''
    substituteInPlace liveMedia/include/Locale.hh \
      --replace '<xlocale.h>' '<locale.h>'
  '';

  configurePhase = ''
    runHook preConfigure

    ./genMakefiles ${{
      x86_64-darwin = "macosx-catalina";
      i686-linux = "linux";
      x86_64-linux = "linux-64bit";
      aarch64-linux = "linux-64bit";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported platform ${stdenv.hostPlatform.system}")}

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    for dir in BasicUsageEnvironment groupsock liveMedia UsageEnvironment; do
      install -dm755 $out/{bin,lib,include/$dir}
      install -m644 $dir/*.a "$out/lib"
      install -m644 $dir/include/*.h* "$out/include/$dir"
    done

    runHook postInstall
  '';

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
    broken = stdenv.hostPlatform.isAarch64;
  };
}
