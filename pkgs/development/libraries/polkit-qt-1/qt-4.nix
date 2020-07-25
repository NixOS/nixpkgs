{ stdenv, fetchurl, cmake, pkgconfig, polkit, automoc4, glib, qt4 }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "polkit-qt-1-qt4-0.112.0";

  src = fetchurl {
    url = "mirror://kde/stable/apps/KDE4.x/admin/polkit-qt-1-0.112.0.tar.bz2";
    sha256 = "1ip78x20hjqvm08kxhp6gb8hf6k5n6sxyx6kk2yvvq53djzh7yv7";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake pkgconfig automoc4 ];

  propagatedBuildInputs = [ polkit glib qt4 ];

  postFixup =
    ''
      for i in $dev/lib/cmake/*/*.cmake; do
        echo "fixing $i"
        substituteInPlace $i \
          --replace "\''${PACKAGE_PREFIX_DIR}/lib" $out/lib
      done
    '';

  meta = with stdenv.lib; {
    description = "A Qt wrapper around PolKit";
    maintainers = [ maintainers.ttuegel ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
