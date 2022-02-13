{ lib, stdenv, fetchurl, qt4, cmake }:

let
  baseName = "libdbusmenu-qt";
  v = "0.9.2";
  homepage = "https://launchpad.net/${baseName}";
  name = "${baseName}-${v}";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "${homepage}/trunk/${v}/+download/${name}.tar.bz2";
    sha256 = "1v0ri5g9xw2z64ik0kx0ra01v8rpjn2kxprrxppkls1wvav1qv5f";
  };

  buildInputs = [ qt4 ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DWITH_DOC=OFF" ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Provides a Qt implementation of the DBusMenu spec";
    inherit homepage;
    inherit (qt4.meta) platforms;
    license = licenses.lgpl2;
  };
}
