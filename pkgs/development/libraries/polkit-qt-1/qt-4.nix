{ stdenv, fetchurl, cmake, pkgconfig, polkit, automoc4, glib, qt4 }:

with stdenv.lib;

stdenv.mkDerivation {
  name = "polkit-qt-1-qt4-0.112.0";

  src = fetchurl {
    url = "mirror://kde/stable/apps/KDE4.x/admin/polkit-qt-1-0.112.0.tar.bz2";
    sha256 = "1ip78x20hjqvm08kxhp6gb8hf6k5n6sxyx6kk2yvvq53djzh7yv7";
  };

  nativeBuildInputs = [ cmake pkgconfig automoc4 ];

  propagatedBuildInputs = [ polkit glib qt4 ];

  meta = {
    description = "A Qt wrapper around PolKit";
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
