{ stdenv, fetchurl, zlib }:

assert zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.5.19";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "1s990cdsdlbb78aq4sj2vq2849p2nbbbnbk5p8f9w45rn0v5q98y";
  };

  propagatedBuildInputs = [ zlib ];

  doCheck = true;

  passthru = { inherit zlib; };

  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = stdenv.lib.licenses.libpng;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    branch = "1.5";
  };
}
