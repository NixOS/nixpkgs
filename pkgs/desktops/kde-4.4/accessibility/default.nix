{stdenv, fetchurl, lib, cmake, qt4, perl, alsaLib, libXi, libXtst, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeaccessibility-4.4.3";
  src = fetchurl {
    url = mirror://kde/stable/4.4.3/src/kdeaccessibility-4.4.3.tar.bz2;
    sha256 = "1j1v0bfl6kcapxwqa1ma19z61qx2vd4lx7b9dykkv7z3gq7c5y5m";
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
