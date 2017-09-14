{stdenv, fetchurl, yasm, enable10bit ? false}:

stdenv.mkDerivation rec {
  version = "20170731-2245";
  name = "x264-${version}";

  src = fetchurl {
    url = "http://download.videolan.org/x264/snapshots/x264-snapshot-${version}-stable.tar.bz2";
    sha256 = "01sgk1ps4qfifdnblwa3fxnd8ah6n6zbmfc1sy09cgqcdgzxgj0z";
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
