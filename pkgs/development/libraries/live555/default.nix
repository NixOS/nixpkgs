{ stdenv, fetchurl, lib, darwin }:

# Based on https://projects.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD
stdenv.mkDerivation rec {
  pname = "live555";
  version = "2019.11.22";

  src = fetchurl { # the upstream doesn't provide a stable URL
    urls = [
      "mirror://sourceforge/slackbuildsdirectlinks/live.${version}.tar.gz"
      "https://download.videolan.org/contrib/live555/live.${version}.tar.gz"
    ];
    sha256 = "144y2wsfpaclkj7srx85f3y3parzn7vbjmzc2afc62wdsb9gn46d";
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
    homepage = "http://www.live555.com/liveMedia/";
    changelog = "http://www.live555.com/liveMedia/public/changelog.txt";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isAarch64;
  };
}
