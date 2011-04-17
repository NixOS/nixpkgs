{stdenv, fetchurl, yasm}:

stdenv.mkDerivation rec {
  version = "snapshot-20110416-2245-stable";
  name = "x264-${version}";

  src = fetchurl {
    url = "ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-${version}.tar.bz2";
    sha256 = "17bbczmsln6wmw7vwjmmr18bhngj1b2xfr9fq3a3n54706df9370";
  };

  patchPhase = ''
    sed -i s,/bin/bash,${stdenv.shell}, configure version.sh
  '';

  configureFlags = [ "--enable-shared" ]
    ++ stdenv.lib.optional (!stdenv.isi686) "--enable-pic";

  buildInputs = [ yasm ];

  meta = { 
    description = "library for encoding H264/AVC video streams";
    homepage = http://www.videolan.org/developers/x264.html;
    license = "GPL";
  };
}
