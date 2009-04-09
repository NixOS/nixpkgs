{stdenv, fetchurl, cmake, qt4, perl, xscreensaver,
 kdelibs, kdebase_workspace, automoc4, phonon, strigi, eigen}:

stdenv.mkDerivation {
  name = "kdeartwork-4.2.2";
  src = fetchurl {
    url = mirror://kde/stable/4.2.2/src/kdeartwork-4.2.2.tar.bz2;
    sha1 = "306eede44f62fdef0892ad40988ada51f06bfa73";
  };
  buildInputs = [ cmake qt4 perl xscreensaver
                  kdelibs kdebase_workspace automoc4 phonon strigi eigen ];
}
