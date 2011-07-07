{ stdenv, fetchurl, cmake, qt4, pkgconfig, polkit, automoc4, glib }:

stdenv.mkDerivation rec {
  name = "polkit-qt-1-0.99.0";

  src = fetchurl {
    url = "mirror://kde/stable/apps/KDE4.x/admin/${name}.tar.bz2";
    sha256 = "02m710q34aapbmnz1p6qwgkk5xjmm239zdl3lvjg77dh3j0w5i3r";
  };

  buildInputs = [ cmake qt4 automoc4 ];
  
  propagatedBuildInputs = [ polkit glib ];

  meta = {
    description = "A Qt wrapper around PolKit";
  };
}
