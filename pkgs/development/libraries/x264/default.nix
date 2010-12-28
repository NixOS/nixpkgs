{stdenv, fetchurl, yasm}:

stdenv.mkDerivation rec {
  version = "snapshot-20100624-2245";
  name = "x264-${version}";

  src = fetchurl {
    url = "ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-${version}.tar.bz2";
    sha256 = "0hva3j7h99hl3l1p32a1j6p35s5aakkg3plp8xx1wk6qplxhkqsq";
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
