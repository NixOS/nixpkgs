{ stdenv, fetchurl, zlib }:

assert zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "0il97i4d4q1kacfx0d2bngrciw3r2z9pi3ra9r8ci4gmks5pzxay";
  };

  propagatedBuildInputs = [ zlib ];

  doCheck = true;

  passthru = { inherit zlib; };

  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
  };
}
