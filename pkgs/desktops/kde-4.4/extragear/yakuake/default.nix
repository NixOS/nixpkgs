{ stdenv, fetchurl, kdelibs, cmake, gettext, perl, automoc4, qt4, phonon }:

stdenv.mkDerivation rec {
  name = "yakuake-2.9.6";

  src = fetchurl {
    url = "http://download.berlios.de/yakuake/${name}.tar.bz2";
    sha256 = "08n6kdzk205rq1bs4yx5f2qawz6xigdhn9air0pbjsi1j630yfzq";
  };

  buildInputs = [ kdelibs cmake gettext perl automoc4 qt4 phonon stdenv.gcc.libc ];

  meta = with stdenv.lib; {
    homepage = http://yakuake.kde.org;
    description = "Quad-style terminal emulator for KDE";
    maintainers = [ maintainers.urkud ];
    platforms = platforms.linux;
  };
}
