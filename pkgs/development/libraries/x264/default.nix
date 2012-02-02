{stdenv, fetchurl, yasm}:

stdenv.mkDerivation rec {
  version = "snapshot-20120129-2245-stable";
  name = "x264-${version}";

  src = fetchurl {
    url = "ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-${version}.tar.bz2";
    sha256 = "1i63xsa46a5l0ys3mqbcqr4gr5kpaf9fs05cbf0782iir5k07pcr";
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
