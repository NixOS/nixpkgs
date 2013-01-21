{ stdenv, fetchurl, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "qjson-0.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/qjson/${name}.tar.bz2";
    sha256 = "155r7nypgnsvjc6w3q51zmjchpqxi4c3azad9cf1fip8bws993iv";
  };

  buildInputs = [ cmake qt4 ];

  meta = {
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (qt4.meta) platforms;
  };
}
