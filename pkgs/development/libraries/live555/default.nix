{ stdenv, fetchurl, lib, darwin }:

# Based on https://projects.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD
stdenv.mkDerivation rec {
  name = "live555-${version}";
  version = "2019.04.24";

  src = fetchurl { # the upstream doesn't provide a stable URL
    urls = [
      "mirror://sourceforge/slackbuildsdirectlinks/live.${version}.tar.gz"
      "https://download.videolan.org/contrib/live555/live.${version}.tar.gz"
    ];
    sha256 = "0wnxc4g04afsash1jn240zgdzh6lxa6rsaghahk34zlllb74dgdv";
  };

  postPatch = ''
    sed 's,/bin/rm,rm,g' -i genMakefiles
    sed \
      -e 's/$(INCLUDES) -I. -O2 -DSOCKLEN_T/$(INCLUDES) -I. -O2 -I. -fPIC -DRTSPCLIENT_SYNCHRONOUS_INTERFACE=1 -DSOCKLEN_T/g' \
      -i config.linux
  '' + stdenv.lib.optionalString (stdenv ? glibc) ''
    substituteInPlace liveMedia/include/Locale.hh \
      --replace '<xlocale.h>' '<locale.h>'
  '';

  configurePhase = ''
    runHook preConfigure

    ./genMakefiles ${{
      x86_64-darwin = "macosx";
      i686-linux = "linux";
      x86_64-linux = "linux-64bit";
      aarch64-linux = "linux-64bit";
    }.${stdenv.hostPlatform.system}}

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

  nativeBuildInputs = lib.optional stdenv.isDarwin darwin.cctools;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Set of C++ libraries for multimedia streaming, using open standard protocols (RTP/RTCP, RTSP, SIP)";
    homepage = http://www.live555.com/liveMedia/;
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isAarch64;
  };
}
