{ stdenv, fetchurl, qt4, cmake }:

let
  baseName = "libdbusmenu-qt";
  v = "0.9.0";
in

stdenv.mkDerivation rec {
  name = "${baseName}-${v}";

  src = fetchurl {
    url = "http://launchpad.net/${baseName}/trunk/${v}/+download/${name}.tar.bz2";
    sha256 = "0xdicb3fmwgbyhc6cpcmdkwysdg18m5rcqc3izpwv6brq4aq4787";
  };

  buildInputs = [ qt4 ];
  buildNativeInputs = [ cmake ];

  cmakeFlags = "-DWITH_DOC=OFF";
  
  meta = with stdenv.lib; {
    description = "Provides a Qt implementation of the DBusMenu spec";
    homepage = http://people.canonical.com/~agateau/dbusmenu/;
    maintainers = [ maintainers.urkud ];
    inherit (qt4.meta) platforms;
  };
}
