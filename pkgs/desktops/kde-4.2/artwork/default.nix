{stdenv, fetchurl, cmake, qt4, perl, xscreensaver,
 kdelibs, kdebase_workspace, automoc4, phonon, strigi, eigen}:

stdenv.mkDerivation {
  name = "kdeartwork-4.2.0";
  src = fetchurl {
    url = mirror://kde/stable/4.2.0/src/kdeartwork-4.2.0.tar.bz2;
    md5 = "d81623b60c7deb314bc2e28a52254ac2";
  };
  buildInputs = [ cmake qt4 perl xscreensaver
                  kdelibs kdebase_workspace automoc4 phonon strigi eigen ];
}
