{ stdenv, fetchurl, cmake, pkgconfig, polkit, automoc4, glib
, qt4 ? null
, withQt5 ? false, qtbase ? null }:

with stdenv.lib;

assert (withQt5 -> qtbase != null); assert (!withQt5 -> qt4 != null);

stdenv.mkDerivation {
  name = "polkit-qt-1-0.112.0";

  outputs = [ "dev" "out" ];

  src = fetchurl {
    url = "mirror://kde/stable/apps/KDE4.x/admin/polkit-qt-1-0.112.0.tar.bz2";
    sha256 = "1ip78x20hjqvm08kxhp6gb8hf6k5n6sxyx6kk2yvvq53djzh7yv7";
  };

  nativeBuildInputs = [ cmake pkgconfig ] ++ optional (!withQt5) automoc4;

  propagatedBuildInputs = [ polkit glib ] ++ [(if withQt5 then qtbase else qt4)];

  preConfigure = ''
    cmakeFlags+=" -DCMAKE_INSTALL_LIBDIR=''${!outputLib}/lib"
  '';

  postFixup = ''
    # Fix library location in CMake module
    sed -i "$dev/lib/cmake/PolkitQt5-1/PolkitQt5-1Config.cmake" \
        -e "s,set_and_check.POLKITQT-1_LIB_DIR.*$,set_and_check(POLKITQT-1_LIB_DIR \"''${!outputLib}/lib\"),"
  '';

  meta = {
    description = "A Qt wrapper around PolKit";
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
