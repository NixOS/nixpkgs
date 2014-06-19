{ stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, automoc4, soprano, sqlite }:

stdenv.mkDerivation rec {
  name = "akonadi-1.11.0";
  
  src = fetchurl {
    url = "mirror://kde/stable/akonadi/src/${name}.tar.bz2";
    sha256 = "0k96i8xq3xkm5rrxrj3zqgppcmqbzcpc918xnx0p54jkkm85gchc";
  };

  buildInputs = [ qt4 soprano libxslt boost sqlite ];

  nativeBuildInputs = [ cmake automoc4 shared_mime_info ];

  enableParallelBuilding = true;
  
  meta = with stdenv.lib; {
    description = "KDE PIM Storage Service";
    license = "LGPL";
    homepage = http://pim.kde.org/akonadi;
    maintainers = [ maintainers.sander maintainers.urkud maintainers.phreedom ];
    platforms = platforms.linux;
  };
}
