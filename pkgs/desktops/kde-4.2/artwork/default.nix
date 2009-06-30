{stdenv, fetchurl, cmake, qt4, perl, xscreensaver,
 kdelibs, kdebase_workspace, automoc4, phonon, strigi, eigen}:

stdenv.mkDerivation {
  name = "kdeartwork-4.2.4";
  src = fetchurl {
    url = mirror://kde/stable/4.2.4/src/kdeartwork-4.2.4.tar.bz2;
    sha1 = "601fa04bc6fb9bdd5dfa094af04ad204bcc20b14";
  };
  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 perl xscreensaver
                  kdelibs kdebase_workspace automoc4 phonon strigi eigen ];
}
