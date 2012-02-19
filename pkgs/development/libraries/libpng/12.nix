{ stdenv, fetchurl, zlib, xz }:

assert zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.2.47";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "1lai3dnzw81y40jr17bdj1qh08hwv9mc1v74yybl7jdx2hiilsvx";
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
