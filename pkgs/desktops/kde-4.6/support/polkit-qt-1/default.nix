{ kde, fetchurl, cmake, qt4, pkgconfig, polkit, automoc4, glib }:

kde.package rec {
  buildInputs = [ cmake qt4 automoc4 ];
  propagatedBuildInputs = [ polkit glib ];

  src = fetchurl {
    url = with meta.kde;
      "mirror://kde/stable/apps/KDE4.x/admin/${name}-${version}.tar.bz2";
    sha256 = "02m710q34aapbmnz1p6qwgkk5xjmm239zdl3lvjg77dh3j0w5i3r";
  };

  patches = [ ./policy-files.patch ];

  meta.kde = {
    name = "polkit-qt-1";
    version = "0.99.0";
  };
}
