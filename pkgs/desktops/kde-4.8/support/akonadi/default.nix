{ stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, automoc4, soprano }:

stdenv.mkDerivation rec {
  name = "akonadi-1.7.0";
  
  src = fetchurl {
    url = "mirror://kde/stable/akonadi/src/${name}.tar.bz2";
    sha256 = "105mjr6n1g6kl0djp2l8jr8b7j4s9gy2ls43g1wf3py1hf6j5fdz";
  };

  buildInputs = [ qt4 soprano libxslt boost ];

  buildNativeInputs = [ cmake automoc4 shared_mime_info ];

  enableParallelBuilding = true;
  
  meta = with stdenv.lib; {
    description = "KDE PIM Storage Service";
    license = "LGPL";
    homepage = http://pim.kde.org/akonadi;
    maintainers = [ maintainers.sander maintainers.urkud ];
    platforms = platforms.linux;
  };
}
