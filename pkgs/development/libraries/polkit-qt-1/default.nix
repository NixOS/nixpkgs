{ stdenv, fetchurl, cmake, pkgconfig, polkit, automoc4, glib
, qt4 ? null, qt5 ? null, withQt5 ? false }:

assert (withQt5 -> qt5 != null); assert (!withQt5 -> qt4 != null);

stdenv.mkDerivation {
  name = "polkit-qt-1-0.112.0";

  src = fetchurl {
    url = "mirror://kde/stable/apps/KDE4.x/admin/polkit-qt-1-0.112.0.tar.bz2";
    sha256 = "1ip78x20hjqvm08kxhp6gb8hf6k5n6sxyx6kk2yvvq53djzh7yv7";
  };

  nativeBuildInputs = [ cmake automoc4 pkgconfig ];

  propagatedBuildInputs = [ polkit glib (if withQt5 then qt5 else qt4) ];

  meta = {
    description = "A Qt wrapper around PolKit";
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
  };
}
