{stdenv, fetchurl, cmake, qt4, perl, xscreensaver,
 kdelibs, kdebase_workspace, automoc4, phonon, strigi, eigen}:

stdenv.mkDerivation {
  name = "kdeartwork-4.2.1";
  src = fetchurl {
    url = mirror://kde/stable/4.2.1/src/kdeartwork-4.2.1.tar.bz2;
    sha1 = "02bd99ca5cf303bdeb991b3e85b45dfc4e69e0bc";
  };
  buildInputs = [ cmake qt4 perl xscreensaver
                  kdelibs kdebase_workspace automoc4 phonon strigi eigen ];
}
