{ stdenv, fetchurl, qt4, cmake, doxygen }:

let
  baseName = "libdbusmenu-qt";
  v = "0.8.2";
in

stdenv.mkDerivation rec {
  name = "${baseName}-${v}";

  src = fetchurl {
    url = "http://launchpad.net/${baseName}/trunk/${v}/+download/${name}.tar.bz2";
    sha256 = "0fazwj4nhh9lr7zwz9ih20i6w60zlni3hcdwj6kz6521bkr8zg2s";
  };

  buildInputs = [ cmake qt4 doxygen ];
  
  meta = with stdenv.lib; {
    description = "Provides a Qt implementation of the DBusMenu spec";
    homepage = http://people.canonical.com/~agateau/dbusmenu/;
    maintainers = [ maintainers.urkud ];
    inherit (qt4.meta) platforms;
  };
}
