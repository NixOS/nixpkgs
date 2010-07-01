{ stdenv, fetchurl, lib, cmake, qt4, perl, gettext, libXScrnSaver
, kdelibs, kdepimlibs, automoc4, phonon, qca2}:

stdenv.mkDerivation {
  name = "konversation-1.3";
  src = fetchurl {
    url = mirror://kde/stable/konversation/1.3/src/konversation-1.3.tar.bz2;
    sha256 = "05gs75j4qza7i7yydy7rcqhp70r6zblbai5k1fygyhsd23ryqq9n";
  };
  buildInputs = [ cmake qt4 perl gettext stdenv.gcc.libc libXScrnSaver kdelibs kdepimlibs automoc4 phonon qca2 ];
  meta = {
    description = "Integrated IRC client for KDE";
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
