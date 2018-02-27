{ stdenv, fetchurl }:

# Based on https://projects.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD
let
  version = "2018.02.12";
in
stdenv.mkDerivation {
  name = "live555-${version}";

  src = fetchurl { # the upstream doesn't provide a stable URL
    url = "mirror://sourceforge/slackbuildsdirectlinks/live.${version}.tar.gz";
    sha256 = "08860q07hfiln44d6qaasmfalf4hb9na5jsfd4yps6jn4r54xxwx";
  };

  postPatch = "sed 's,/bin/rm,rm,g' -i genMakefiles"
  + stdenv.lib.optionalString (stdenv ? glibc) ''

    substituteInPlace liveMedia/include/Locale.hh \
      --replace '<xlocale.h>' '<locale.h>'
  '';

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
