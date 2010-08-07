{ kdePackage, cmake, qt4, pkgconfig, polkit, automoc4, glib }:

kdePackage {
  pn = "polkit-qt-1";
  v = "0.96.1";
  subdir = "apps/KDE4.x/admin";
  sha256 = "1ng5bi1gmr5lg49c5kyqyjzbjhs4w90c2zlnfcyviv9p3wzfgzbr";
} {
  buildInputs = [ cmake qt4 automoc4 ];
  propagatedBuildInputs = [ polkit glib ];
}
