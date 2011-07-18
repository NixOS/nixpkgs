{ stdenv, fetchurl, qt4, cmake, doxygen }:

let
  baseName = "libdbusmenu-qt";
  v = "0.8.3";
in

stdenv.mkDerivation rec {
  name = "${baseName}-${v}";

  src = fetchurl {
    url = "http://launchpad.net/${baseName}/trunk/${v}/+download/${name}.tar.bz2";
    sha256 = "1fkw6wpxjmmx4p8779z662qphip3pgdcsn6cyb0frryfj4sa32ka";
  };

  buildInputs = [ cmake qt4 doxygen ];
  
  meta = with stdenv.lib; {
    description = "Provides a Qt implementation of the DBusMenu spec";
    homepage = http://people.canonical.com/~agateau/dbusmenu/;
    maintainers = [ maintainers.urkud ];
    inherit (qt4.meta) platforms;
  };
}
