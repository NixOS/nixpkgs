{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdetoys-4.4.2.tar.bz2;
    sha256 = "12yqykbl278w19wxaa6yl9m72ykih81v0rwgnfn0bq3zkwj1z5y0";
  };
  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 phonon ];
  meta = {
    description = "KDE Toys";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
