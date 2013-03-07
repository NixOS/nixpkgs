{ stdenv, fetchurl, zlib, xz }:

assert zlib != null;

stdenv.mkDerivation rec {
  name = "libpng-1.2.50";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/${name}.tar.xz";
    sha256 = "1rz8v3cvy1zzpagxn91lj8swb9vf75rz3yyi18v7zb4jihgzh927";
  };

  propagatedBuildInputs = [ zlib ];

  nativeBuildInputs = [ xz ];

  passthru = { inherit zlib; };

  meta = {
    description = "The official reference implementation for the PNG file format";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
  };
}
