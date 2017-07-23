{stdenv, fetchurl, yasm, enable10bit ? false}:

stdenv.mkDerivation rec {
  version = "20160615-2245";
  name = "x264-${version}";

  src = fetchurl {
    url = "http://download.videolan.org/x264/snapshots/x264-snapshot-${version}-stable.tar.bz2";
    sha256 = "0w5l77gm8bsmafzimzyc5s27kcw79r6nai3bpccqy0spyxhjsdc2";
  };

  patchPhase = ''
    sed -i s,/bin/bash,${stdenv.shell}, configure version.sh
  '';

  outputs = [ "out" "lib" ]; # leaving 52 kB of headers

  preConfigure = ''
    # `AS' is set to the binutils assembler, but we need yasm
    unset AS
  '';

  configureFlags = [ "--enable-shared" ]
    ++ stdenv.lib.optional (!stdenv.isi686) "--enable-pic"
    ++ stdenv.lib.optional (enable10bit) "--bit-depth=10";

  buildInputs = [ yasm ];

  meta = with stdenv.lib; {
    description = "Library for encoding H264/AVC video streams";
    homepage    = http://www.videolan.org/developers/x264.html;
    license     = licenses.gpl2;
    platforms   = platforms.unix;
    maintainers = [ maintainers.spwhitt ];
  };
}
