{ stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, automoc4, soprano, sqlite }:

stdenv.mkDerivation rec {
  name = "akonadi-1.10.2";
  
  src = fetchurl {
    url = "mirror://kde/stable/akonadi/src/${name}.tar.bz2";
    sha256 = "1jij7vmrxg4kzqcq4ci73q3m3927bym5xb34kvmpq3h7p1d0vmgk";
  };

  buildInputs = [ qt4 soprano libxslt boost sqlite ];

  nativeBuildInputs = [ cmake automoc4 shared_mime_info ];

  enableParallelBuilding = true;
  
  meta = with stdenv.lib; {
    description = "KDE PIM Storage Service";
    license = "LGPL";
    homepage = http://pim.kde.org/akonadi;
    maintainers = [ maintainers.sander maintainers.urkud ];
    platforms = platforms.linux;
  };
}
