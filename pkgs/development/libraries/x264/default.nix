{stdenv, fetchurl, yasm, enable10bit ? false}:

stdenv.mkDerivation rec {
  version = "20141218-2245";
  name = "x264-${version}";

  src = fetchurl {
    url = "http://download.videolan.org/x264/snapshots/x264-snapshot-${version}-stable.tar.bz2";
    sha256 = "1gp1f0382vh2hmgc23ldqyywcfljg8lsgl2849ymr14r6gxfh69m";
  };

  patchPhase = ''
    sed -i s,/bin/bash,${stdenv.shell}, configure version.sh
  '';

  configureFlags = [ "--enable-shared" ]
    ++ stdenv.lib.optional (!stdenv.isi686) "--enable-pic"
    ++ stdenv.lib.optional (enable10bit) "--bit-depth=10";

  buildInputs = [ yasm ];

  meta = with stdenv.lib; {
    description = "library for encoding H264/AVC video streams";
    homepage    = http://www.videolan.org/developers/x264.html;
    license     = licenses.gpl2;
    platforms   = platforms.unix;
    maintainers = [ maintainers.spwhitt ];
  };
}
