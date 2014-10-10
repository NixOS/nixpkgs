{ stdenv, fetchurl, cmake, pkgconfig, polkit, automoc4, glib
, qt, useQt5 ? false }:

stdenv.mkDerivation rec {
  name = if useQt5 then "polkit-qt5-1-0.112.0" else "polkit-qt-1-0.112.0";

  src = fetchurl {
    url = "mirror://kde/stable/apps/KDE4.x/admin/polkit-qt-1-0.112.0.tar.bz2";
    sha256 = "1ip78x20hjqvm08kxhp6gb8hf6k5n6sxyx6kk2yvvq53djzh7yv7";
  };

  nativeBuildInputs = [ cmake automoc4 ];

  propagatedBuildInputs = [ polkit glib qt ];

  propagatedNativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "A Qt wrapper around PolKit";
  };
}
