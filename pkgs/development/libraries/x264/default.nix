{stdenv, fetchurl, yasm}:

stdenv.mkDerivation rec {
  version = "snapshot-20141218-2245-stable";
  name = "x264-20141218-2245";

  src = fetchurl {
    url = "ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-${version}.tar.bz2";
    sha256 = "1gp1f0382vh2hmgc23ldqyywcfljg8lsgl2849ymr14r6gxfh69m";
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
