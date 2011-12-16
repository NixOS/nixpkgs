{ stdenv, fetchurl, cmake, qt4, pkgconfig, polkit, automoc4, glib }:

stdenv.mkDerivation rec {
  name = "polkit-qt-1-0.103.0";

  src = fetchurl {
    url = "mirror://kde/stable/apps/KDE4.x/admin/${name}.tar.bz2";
    sha256 = "0k17sb70ywk94dmncnkyig03sg1hcfbhi5wlc77xf3rxirmmccif";
  };

  patches = [ ./polkit-install.patch ];

  buildNativeInputs = [ cmake automoc4 ];

  propagatedBuildInputs = [ polkit glib qt4 ];

  meta = {
    description = "A Qt wrapper around PolKit";
  };
}
