{ stdenv, fetchurl, lib, darwin }:

# Based on https://projects.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD
let
  version = "2018.02.28";
in
stdenv.mkDerivation {
  name = "live555-${version}";

  src = fetchurl { # the upstream doesn't provide a stable URL
    url = "mirror://sourceforge/slackbuildsdirectlinks/live.${version}.tar.gz";
    sha256 = "0zi47asv1qmb09g321m02q684i3c90vci0mgkdh1mlmx2rbg1d1d";
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
    ./genMakefiles ${{
      x86_64-darwin = "macosx";
      i686-linux = "linux";
      x86_64-linux = "linux-64bit";
      aarch64-linux = "linux-64bit";
    }.${stdenv.hostPlatform.system}}
  '';

  installPhase = ''
    for dir in BasicUsageEnvironment groupsock liveMedia UsageEnvironment; do
      install -dm755 $out/{bin,lib,include/$dir}
      install -m644 $dir/*.a "$out/lib"
      install -m644 $dir/include/*.h* "$out/include/$dir"
    done
  '';

  nativeBuildInputs = lib.optional stdenv.isDarwin darwin.cctools;

  meta = with lib; {
    description = "Set of C++ libraries for multimedia streaming, using open standard protocols (RTP/RTCP, RTSP, SIP)";
    homepage = http://www.live555.com/liveMedia/;
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
