{ stdenv, fetchurl, zlib, libpng, libjpeg, lcms2 }:

stdenv.mkDerivation rec {
  name = "libmng-2.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/libmng/${name}.tar.xz";
    sha256 = "1lvxnpds0vcf0lil6ia2036ghqlbl740c4d2sz0q5g6l93fjyija";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputMan= "devdoc";

  propagatedBuildInputs = [ zlib libpng libjpeg lcms2 ];

  meta = with stdenv.lib; {
    description = "Reference library for reading, displaying, writing and examining Multiple-Image Network Graphics";
    homepage = "http://www.libmng.com";
    license = licenses.zlib;
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.unix;
  };
}
