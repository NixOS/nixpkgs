{ stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, automoc4, soprano }:

stdenv.mkDerivation rec {
  name = "akonadi-1.6.1";
  
  src = fetchurl {
    url = "mirror://kde/stable/akonadi/src/${name}.tar.bz2";
    sha256 = "0r8sw7m1pwqc7qkaczm0r8adqi1wvlhdp32gy3q5p5plq50xhgra";
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
