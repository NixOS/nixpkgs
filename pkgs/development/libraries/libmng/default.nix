{ stdenv, fetchurl, zlib, libpng, libjpeg, lcms2 }:

stdenv.mkDerivation rec {
  name = "libmng-2.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/libmng/${name}.tar.xz";
    sha256 = "0l5wa3b9rr4zl49zbbjpapqyccqjwzkzw1ph3p4pk9p5h73h9317";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputMan= "devdoc";

  propagatedBuildInputs = [ zlib libpng libjpeg lcms2 ];

  meta = with stdenv.lib; {
    description = "Reference library for reading, displaying, writing and examining Multiple-Image Network Graphics";
    homepage = http://www.libmng.com;
    license = licenses.zlib;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.unix;
  };
}
