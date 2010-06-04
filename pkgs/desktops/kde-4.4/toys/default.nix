{stdenv, fetchurl, lib, cmake, qt4, perl, kdelibs, kdebase_workspace, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdetoys-4.4.4";
  src = fetchurl {
    url = mirror://kde/stable/4.4.4/src/kdetoys-4.4.4.tar.bz2;
    sha256 = "16q5fyvl3j3n6f90kw172rz12m3rf6si3wka3wpgbzz3dcl8hda8";
  };
  buildInputs = [ cmake qt4 perl kdelibs kdebase_workspace automoc4 phonon ];
  meta = {
    description = "KDE Toys";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
