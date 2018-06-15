{stdenv, fetchurl, cmake, zlib, libxml2, eigen, python, cairo, pcre, pkgconfig }:

stdenv.mkDerivation rec {
  name = "openbabel-${version}";
  version = "2.4.1";

  src = fetchurl {
    url = "https://github.com/openbabel/openbabel/archive/openbabel-${stdenv.lib.replaceStrings ["."] ["-"] version}.tar.gz";
    sha256 = "0xm7y859ivq2cp0q08mwshfxm0jq31xkyr4x8s0j6l7khf57yk2r";
  };

  # TODO : perl & python bindings;
  # TODO : wxGTK: I have no time to compile
  # TODO : separate lib and apps
  buildInputs = [ zlib libxml2 eigen python cairo pcre ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = {
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
