{stdenv, fetchurl, cmake, qt4, perl, xscreensaver,
 kdelibs, kdebase_workspace, automoc4, phonon, strigi, eigen}:

stdenv.mkDerivation {
  name = "kdeartwork-4.2.3";
  src = fetchurl {
    url = mirror://kde/stable/4.2.3/src/kdeartwork-4.2.3.tar.bz2;
    sha1 = "f438060107caeb5bddd1e23a1417edf4e8476158";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl xscreensaver
                  kdelibs kdebase_workspace automoc4 phonon strigi eigen ];
}
