{ stdenv, fetchbzr, cmake, qtbase }:

stdenv.mkDerivation {
  name = "libdbusmenu-qt-0.9.3+14";

  src = fetchbzr {
    url = "http://bazaar.launchpad.net/~dbusmenu-team/libdbusmenu-qt/trunk";
    rev = "ps-jenkins@lists.canonical.com-20140619090718-mppiiax5atpnb8i2";
    sha256 = "1dbhaljyivbv3wc184zpjfjmn24zb6aj72wgg1gg1xl5f783issd";
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = "-DWITH_DOC=OFF";

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/libdbusmenu-qt;
    description = "Provides a Qt implementation of the DBusMenu spec";
    maintainers = [ maintainers.ttuegel ];
    inherit (qtbase.meta) platforms;
  };
}
