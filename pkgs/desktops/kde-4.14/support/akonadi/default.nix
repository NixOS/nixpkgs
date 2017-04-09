{ stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, automoc4, soprano, sqlite, pkgconfig }:

stdenv.mkDerivation rec {
  name = "akonadi-1.13.0";
  
  src = fetchurl {
    url = "mirror://kde/stable/akonadi/src/${name}.tar.bz2";
    sha256 = "8c7f690002ea22c139f3a64394aef2e816e00ca47fd971af7d54a66087356dd2";
  };

  buildInputs = [ qt4 soprano libxslt boost sqlite ];

  nativeBuildInputs = [ cmake automoc4 shared_mime_info pkgconfig ];

  enableParallelBuilding = true;
  
  meta = with stdenv.lib; {
    description = "KDE PIM Storage Service";
    license = "LGPL";
    homepage = http://pim.kde.org/akonadi;
    maintainers = [ maintainers.sander maintainers.phreedom ];
    platforms = platforms.linux;
  };
}
