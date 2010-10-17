{ kde, cmake, qt4, pkgconfig, polkit, automoc4, glib }:

kde.package {
  buildInputs = [ cmake qt4 automoc4 ];
  propagatedBuildInputs = [ polkit glib ];
  meta.kde = {
    name = "polkit-qt-1";
    version = "0.96.1";
    subdir = "apps/KDE4.x/admin";
  };
}
