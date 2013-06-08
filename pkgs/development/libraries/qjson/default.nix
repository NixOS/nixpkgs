{ stdenv, fetchurl, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "qjson-0.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/qjson/${name}.tar.bz2";
    sha256 = "1n8lr2ph08yhcgimf4q1pnkd4z15v895bsf3m68ljz14aswvakfd";
  };

  buildInputs = [ cmake qt4 ];

  meta = {
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (qt4.meta) platforms;
  };
}
