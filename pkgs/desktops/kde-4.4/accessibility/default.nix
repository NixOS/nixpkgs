{stdenv, fetchurl, lib, cmake, qt4, perl, alsaLib, libXi, libXtst, kdelibs, automoc4, phonon}:

stdenv.mkDerivation {
  name = "kdeaccessibility-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdeaccessibility-4.4.5.tar.bz2;
    sha256 = "1j8ndr7hjkqka64kyy7whxg9vzxyym0a6pd1wbr6hp1a99mhz4jv";
  };
  # Missing: speechd, I was too lazy to implement this
  buildInputs = [ cmake qt4 perl alsaLib libXi libXtst kdelibs automoc4 phonon ];
  meta = {
    description = "KDE accessibility tools";
    license = "GPL";
    homepage = http://www.kde.org;
    inherit (kdelibs.meta) maintainers platforms;
  };
}
