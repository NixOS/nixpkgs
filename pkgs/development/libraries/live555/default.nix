{ stdenv, fetchurl }:

# Based on https://projects.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD

stdenv.mkDerivation rec {
  name = "live555-2015.10.12";

  src = fetchurl {
    url = "http://www.live555.com/liveMedia/public/live.2015.10.12.tar.gz";
    md5 = "bcbe18f0b4eb65ee0157333684d6c551";
  };

  buildInputs = [];

  configurePhase = ''
    sed \
      -e 's/$(INCLUDES) -I. -O2 -DSOCKLEN_T/$(INCLUDES) -I. -O2 -I. -fPIC -DRTSPCLIENT_SYNCHRONOUS_INTERFACE=1 -DSOCKLEN_T/g' \
      -i config.linux
     ./genMakefiles linux
  '';

  installPhase = ''
    for dir in BasicUsageEnvironment groupsock liveMedia UsageEnvironment; do
      install -dm755 $out/{bin,lib,include/$dir}
      install -m644 $dir/*.a "$out/lib"
      install -m644 $dir/include/*.h* "$out/include/$dir"
    done
  '';

  meta = with stdenv.lib; {
    description = "Set of C++ libraries for multimedia streaming, using open standard protocols (RTP/RTCP, RTSP, SIP)";
    homepage = http://www.live555.com/liveMedia/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
