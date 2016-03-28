{stdenv, fetchurl, cmake, zlib, libxml2, eigen, python, cairo, pkgconfig }:

stdenv.mkDerivation rec {
  name = "openbabel-2.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/openbabel/${name}.tar.gz";
    sha256 = "122if0jkm71ngd1b0dic8k567b3j2hcikbwnpxgchv5ag5ka5b2f";
  };

  # TODO : perl & python bindings;
  # TODO : wxGTK: I have no time to compile
  # TODO : separate lib and apps
  buildInputs = [ zlib libxml2 eigen python cairo ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = {
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    broken = true; # doesn't build with GCC 5; fix in GitHub
  };
}
