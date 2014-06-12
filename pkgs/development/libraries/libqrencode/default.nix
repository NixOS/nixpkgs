{ stdenv, fetchurl, pkgconfig, libpng }:

let
  version = "3.4.3";
in
stdenv.mkDerivation {
  name = "libqrencode-${version}";

  src = fetchurl {
    url = "http://fukuchi.org/works/qrencode/qrencode-${version}.tar.bz2";
    sha256 = "163sb580p570p27imc6jhkfdw15kzp8vy1jq92nip1rwa63i9myz";
  };

  buildInputs = [ pkgconfig libpng ];

  meta = with stdenv.lib; {
    description = "C library for encoding data in a QR Code symbol";
    longDescription = "Libqrencode is a C library for encoding data in a QR Code symbol, a kind of 2D symbology that can be scanned by handy terminals such as a mobile phone with CCD. The capacity of QR Code is up to 7000 digits or 4000 characters, and is highly robust.";
    homepage = http://fukuchi.org/works/qrencode/index.html;
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.emery ];
    platforms = platforms.all;
  };
} 