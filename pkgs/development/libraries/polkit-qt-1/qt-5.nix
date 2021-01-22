{ lib, stdenv, fetchurl, cmake, pkg-config, polkit, glib, qtbase }:

with lib;

stdenv.mkDerivation {
  name = "polkit-qt-1-qt5-0.112.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://kde/stable/apps/KDE4.x/admin/polkit-qt-1-0.112.0.tar.bz2";
    sha256 = "1ip78x20hjqvm08kxhp6gb8hf6k5n6sxyx6kk2yvvq53djzh7yv7";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  propagatedBuildInputs = [ polkit glib qtbase ];

  postFixup = ''
    # Fix library location in CMake module
    sed -i "$dev/lib/cmake/PolkitQt5-1/PolkitQt5-1Config.cmake" \
        -e "s,\\(set_and_check.POLKITQT-1_LIB_DIR\\).*$,\\1 \"''${!outputLib}/lib\"),"
  '';

  meta = {
    description = "A Qt wrapper around PolKit";
    maintainers = with lib.maintainers; [ ttuegel ];
    platforms = with lib.platforms; linux;
  };
}
