{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  version = "1.5.14";
  name = "libpng-apng-${version}";

  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng15/${version}/libpng-${version}-apng.patch.gz";
    sha256 = "1vcqbkdssy4srm8jqyzaipdc70xzanilqssypmwqyngp8ph0m45p";
  };

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${version}.tar.xz";
    sha256 = "0m3vz3gig7s63zanq5b1dgb5ph12qm0cylw4g4fbxlsq3f74hn8l";
  };

  preConfigure = ''
    gunzip < ${patch_src} | patch -Np1
  '';

  propagatedBuildInputs = [ zlib ];

  passthru = { inherit zlib; };

  meta = {
    description = "The official reference implementation for the PNG file format with animation patch";
    homepage = http://www.libpng.org/pub/png/libpng.html;
    license = "free-non-copyleft"; # http://www.libpng.org/pub/png/src/libpng-LICENSE.txt
  };
}
