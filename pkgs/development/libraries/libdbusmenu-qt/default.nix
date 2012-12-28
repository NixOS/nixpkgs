{ stdenv, fetchurl, qt4, cmake }:

let
  baseName = "libdbusmenu-qt";
  v = "0.9.0";
  homepage = "http://launchpad.net/${baseName}";
  name = "${baseName}-${v}";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "${homepage}/trunk/${v}/+download/${name}.tar.bz2";
    sha256 = "0xdicb3fmwgbyhc6cpcmdkwysdg18m5rcqc3izpwv6brq4aq4787";
  };

  buildInputs = [ qt4 ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = "-DWITH_DOC=OFF";
  
  meta = with stdenv.lib; {
    description = "Provides a Qt implementation of the DBusMenu spec";
    inherit homepage;
    maintainers = [ maintainers.urkud ];
    inherit (qt4.meta) platforms;
  };
}
