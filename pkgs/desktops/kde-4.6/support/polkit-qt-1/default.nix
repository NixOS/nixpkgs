{ kde, fetchurl, cmake, qt4, pkgconfig, polkit, automoc4, glib }:

kde.package rec {
  buildInputs = [ cmake qt4 automoc4 ];
  propagatedBuildInputs = [ polkit glib ];

  src = fetchurl {
    url = with meta.kde;
      "mirror://kde/stable/apps/KDE4.x/admin/${name}-${version}.tar.bz2";
    sha256 = "1ng5bi1gmr5lg49c5kyqyjzbjhs4w90c2zlnfcyviv9p3wzfgzbr";
  };

  meta.kde = {
    name = "polkit-qt-1";
    version = "0.96.1";
  };
}
