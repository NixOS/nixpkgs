{ stdenv, fetchurl, zlib, xz }:

assert zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.5.5";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "03rsqxhrvpiklagzldjqpgs8v43xnb56adn2ramsbdhrnz68pdsi";
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
