{ stdenv, fetchurl, hunspell, pkgconfig, perl }:

stdenv.mkDerivation rec {
  name = "mythes-1.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/hunspell/${name}.tar.gz";
    sha256 = "0f5q7yiwg9bw4a5zxg0dapqdfc2grfb4ss34ifir3mhhy4q3jf4j";
  };

  buildInputs = [ hunspell ];
  nativeBuildInputs = [ pkgconfig perl ];

  meta = {
    homepage = http://hunspell.sourceforge.net/;
    description = "Thesaurus library from Hunspell project";
    inherit (hunspell.meta) platforms;
  };
}
