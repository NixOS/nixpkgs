{ stdenv, fetchurl, cmake, qt4, pkgconfig, polkit, automoc4, glib }:

stdenv.mkDerivation rec {
  name = "polkit-qt-1-0.96.1";
  
  src = fetchurl {
    url = "mirror://kde/stable/apps/KDE4.x/admin/${name}.tar.bz2";
    sha256 = "1ng5bi1gmr5lg49c5kyqyjzbjhs4w90c2zlnfcyviv9p3wzfgzbr";
  };

  buildInputs = [ cmake qt4 automoc4 ];
  propagatedBuildInputs = [ polkit glib ];
}
