{ stdenv, fetchurl, qt4, cmake }:

let
  baseName = "libdbusmenu-qt";
  v = "0.7.0";
in
stdenv.mkDerivation rec {
  name = "${baseName}-${v}";

  src = fetchurl {
    url = "http://launchpad.net/${baseName}/trunk/${v}/+download/${name}.tar.bz2";
    sha256 = "0zn3w57xjk34j08fx4n757kakkd4y07halrnaj4a0x0c9dhyjf14";
  };

  buildInputs = [ cmake qt4 ];
  
  meta = with stdenv.lib; {
    description = "Provides a Qt implementation of the DBusMenu spec";
    homepage = http://people.canonical.com/~agateau/dbusmenu/;
    maintainers = [ maintainers.urkud ];
    inherit (qt4.meta) platforms;
  };
}
