{stdenv, fetchurl, lib, cmake, qt4, perl, alsaLib, libXi, libXtst, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeaccessibility-4.4.1";
  src = fetchurl {
    url = mirror://kde/stable/4.4.1/src/kdeaccessibility-4.4.1.tar.bz2;
    sha256 = "09hnac6qx7svn86ch0qm8qq1cbad9fr998q0732x2x1xink387hw";
  };
  # Missing: speechd, I was too lazy to implement this
  buildInputs = [ cmake qt4 perl alsaLib libXi libXtst kdelibs automoc4 phonon ];
  meta = {
    description = "KDE accessibility tools";
    license = "GPL";
    homepage = http://www.kde.org;
    maintainers = [ lib.maintainers.sander ];
  };
}
