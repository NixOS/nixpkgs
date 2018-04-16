{ stdenv, lib, fetchurl }:

let
  target = "linux-with-shared-libraries";

in stdenv.mkDerivation rec {
  name = "live555-${version}";
  version = "2018-02-28";

  # old versions are aggressively purged from upstream
  src = fetchurl {
    url = "http://live555.com/liveMedia/public/live.${lib.replaceStrings [ "-" ] [ "." ] version}.tar.gz";
    sha256 = "0zi47asv1qmb09g321m02q684i3c90vci0mgkdh1mlmx2rbg1d1d";
  };

  # Arch Linux does this but I don't know *why*
  postPatch = ''
    substituteInPlace genMakefiles \
      --replace /bin/rm rm

    substituteInPlace config.${target} --replace \
      '-DSOCKLEN_T' \
      '-fPIC -DRTSPCLIENT_SYNCHRONOUS_INTERFACE=1 -DSOCKLEN_T'
  '';

  configurePhase = ''
    runHook preConfigure

    ./genMakefiles ${target}

    runHook postConfigure
  '';

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Set of C++ libraries for multimedia streaming, using open standard protocols (RTP/RTCP, RTSP, SIP)";
    homepage = http://www.live555.com/liveMedia/;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
