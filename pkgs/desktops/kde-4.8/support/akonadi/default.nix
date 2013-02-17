{ stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, automoc4, soprano }:

stdenv.mkDerivation rec {
  name = "akonadi-1.7.2";
  
  src = fetchurl {
    url = "mirror://kde/stable/akonadi/src/${name}.tar.bz2";
    sha256 = "07rbhc8aa3d896j2r64ljv3amd6s4xhlbgq7kx99m1f68yl1fwjb";
  };

  buildInputs = [ qt4 soprano libxslt boost ];

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
