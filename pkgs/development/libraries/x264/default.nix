{ stdenv, fetchurl, nasm }:

stdenv.mkDerivation rec {
  pname = "x264";
  version = "20190517-2245";

  src = fetchurl {
    url = "https://download.videolan.org/x264/snapshots/x264-snapshot-${version}-stable.tar.bz2";
    sha256 = "1xv41z04km3rf374xk3ny7v8ibr211ph0j5am0909ln63mphc48f";
  };

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  outputs = [ "out" "lib" "dev" ];

  preConfigure = ''
    # `AS' is set to the binutils assembler, but we need nasm
    unset AS
  '';

  configureFlags = [ "--enable-shared" ]
    ++ stdenv.lib.optional (!stdenv.isi686) "--enable-pic";

  nativeBuildInputs = [ nasm ];

  meta = with stdenv.lib; {
    description = "Library for encoding H264/AVC video streams";
    homepage    = http://www.videolan.org/developers/x264.html;
    license     = licenses.gpl2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ spwhitt tadeokondrak ];
  };
}
