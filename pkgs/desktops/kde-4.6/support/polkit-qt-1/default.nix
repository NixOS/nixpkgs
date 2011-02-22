{ stdenv, fetchurl, cmake, qt4, pkgconfig, polkit, automoc4, glib }:

stdenv.mkDerivation rec {
  name = "polkit-qt-1-0.99.0";

  buildInputs = [ qt4 automoc4 ];
  propagatedBuildInputs = [ polkit glib ];
  buildNativeInputs = [ cmake pkgconfig ];

  src = fetchurl {
    url = "mirror://kde/stable/apps/KDE4.x/admin/${name}.tar.bz2";
    sha256 = "02m710q34aapbmnz1p6qwgkk5xjmm239zdl3lvjg77dh3j0w5i3r";
  };

  patches = [ ./policy-files.patch ];

  meta = {
    maintainers = with stdenv.lib.maintainers; [ urkud sander ];
  };
}
