{ lib, stdenv, fetchgit, cmake, qtbase }:

stdenv.mkDerivation rec {
  pname = "libdbusmenu-qt";
  version = "0.9.3+16";

  src = fetchgit {
    url = "https://git.launchpad.net/ubuntu/+source/libdbusmenu-qt";
    rev = "import/${version}.04.20160218-1";
    sha256 = "039yvklhbmfbcynrbqq9n5ywmj8bjfslnkzcnwpzyhnxdzb6yxlx";
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DWITH_DOC=OFF" ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://launchpad.net/libdbusmenu-qt";
    description = "Provides a Qt implementation of the DBusMenu spec";
    maintainers = [ maintainers.ttuegel ];
    inherit (qtbase.meta) platforms;
    license = licenses.lgpl2;
  };
}
