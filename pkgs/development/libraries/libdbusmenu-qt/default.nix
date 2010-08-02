{ stdenv, fetchurl, qt4, cmake }:

let
  baseName = "libdbusmenu-qt";
  v = "0.5.1";
in
stdenv.mkDerivation rec {
  name = "${baseName}-${v}";

  src = fetchurl {
    url = "http://launchpad.net/${baseName}/trunk/${v}/+download/${name}.tar.bz2";
    sha256 = "0ipz1f08d2wgg18l12wssv9lhm66xhj31a1dbikg2rzw7c6bvjvk";
  };

  buildInputs = [ cmake qt4 ];
  
  meta = with stdenv.lib; {
    description = "Provides a Qt implementation of the DBusMenu spec";
    homepage = http://people.canonical.com/~agateau/dbusmenu/;
    maintainers = [ maintainers.urkud ];
    inherit (qt4.meta) platforms;
  };
}
