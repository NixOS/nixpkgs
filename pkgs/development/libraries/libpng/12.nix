{ stdenv, fetchurl, zlib, xz }:

assert zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.2.46";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "0rcx4v4khdkrvz7b02fmx7lab2pk1lal4dhx9widv36b7g2xvwzn";
  };

  propagatedBuildInputs = [ zlib ];

  buildNativeInputs = [ xz ];

  passthru = { inherit zlib; };

  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
  };
}
