{ kdePackage, cmake, qt4, pkgconfig, polkit, automoc4, glib }:

kdePackage {
  pn = "polkit-qt-1";
  v = "0.96.1";
  subdir = "apps/KDE4.x/admin";

  buildInputs = [ cmake qt4 automoc4 ];
  propagatedBuildInputs = [ polkit glib ];
}
