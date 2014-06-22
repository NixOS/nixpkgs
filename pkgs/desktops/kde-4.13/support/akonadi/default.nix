{ stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, automoc4, soprano
, sqlite, mysql, pkgconfig }:

stdenv.mkDerivation rec {
  name = "akonadi-1.12.1";
  
  src = fetchurl {
    url = "mirror://kde/stable/akonadi/src/${name}.tar.bz2";
    sha256 = "0i9iv3lsqhkb51d4xnn6xaimignw8i64nbgkda1wznwbva7j4wx0";
  };

  buildInputs = [ qt4 soprano libxslt boost sqlite mysql ];

  nativeBuildInputs = [ cmake automoc4 shared_mime_info pkgconfig ];

  enableParallelBuilding = true;
  
  meta = with stdenv.lib; {
    description = "KDE PIM Storage Service";
    license = "LGPL";
    homepage = http://pim.kde.org/akonadi;
    maintainers = with maintainers; [ sander urkud phreedom wmertens ];
    platforms = platforms.linux;
  };
}
