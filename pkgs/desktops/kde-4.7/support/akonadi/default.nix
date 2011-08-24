{ stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, automoc4, soprano }:

stdenv.mkDerivation rec {
  name = "akonadi-1.6.0";
  
  src = fetchurl {
    url = "mirror://kde/stable/akonadi/src/${name}.tar.bz2";
    sha256 = "0bzr6476yyinvdhrn9z8ynmi0py9zs3dfhwk3dvqxysk87svk71f";
  };
  
  buildInputs = [ cmake qt4 soprano automoc4 shared_mime_info libxslt boost ];

  enableParallelBuilding = true;
  
  meta = with stdenv.lib; {
    description = "KDE PIM Storage Service";
    license = "LGPL";
    homepage = http://pim.kde.org/akonadi;
    maintainers = [ maintainers.sander maintainers.urkud ];
    platforms = platforms.linux;
  };
}
