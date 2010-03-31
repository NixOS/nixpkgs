{stdenv, fetchurl, lib, cmake, qt4, perl, alsaLib, libXi, libXtst, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeaccessibility-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdeaccessibility-4.4.2.tar.bz2;
    sha256 = "10n08w7x5sna0ilc965yi1041dwm13s5r4fd1valmlx8wcckrj6q";
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
