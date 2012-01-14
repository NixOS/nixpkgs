{stdenv, fetchurl, cmake, zlib, libxml2, eigen, python, cairo, pkgconfig }:

stdenv.mkDerivation rec {
  name = "openbabel-2.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/openbabel/${name}.tar.gz";
    sha256 = "18yprqsk0fi1ri4fmvpx2ym6gx9fp3by681pl3jffpjqmz4qnbly";
  };

  # TODO : perl & python bindings;
  # TODO : wxGTK: I have no time to compile
  # TODO : separate lib and apps
  buildInputs = [ zlib libxml2 eigen python cairo ];

  buildNativeInputs = [ cmake pkgconfig ];

  meta = {
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
