{ stdenv, fetchurl, cmake }:
let version = "3.0.0";
in stdenv.mkDerivation rec {
  name = "tinyxml-2-${version}";
  src = fetchurl {
    url = "https://github.com/leethomason/tinyxml2/archive/${version}.tar.gz";
    sha256 = "0ispg7ngkry8vhzzawbq42y8gkj53xjipkycw0rkhh487ras32hj";
  };

  configurePhase = ''
    cmake -DCMAKE_INSTALL_PREFIX=$out .
  '';

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = http://www.grinninglizard.com/tinyxml2/;
    description = "simple, small, efficient C++ XML parser from the author of tinyxml";
    maintainers = with maintainers; [ therealpxc ];
    platforms = platforms.all;
  };
}
