{stdenv, fetchurl, lib, cmake, qt4, perl, alsaLib, libXi, libXtst, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeaccessibility-4.3.4";
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/kdeaccessibility-4.3.4.tar.bz2;
    sha1 = "96aa150b8a5c368b6bb36476ed5fb3e3b3c30547";
  };
  buildInputs = [ cmake qt4 perl alsaLib libXi libXtst kdelibs automoc4 phonon ];
  meta = {
    description = "KDE accessibility tools";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
