{ stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, automoc4, soprano }:

stdenv.mkDerivation rec {
  name = "akonadi-1.6.90";
  
  src = fetchurl {
    url = "mirror://kde/stable/akonadi/src/${name}.tar.bz2";
    sha256 = "0a35wkrrdk4k7kw1d4rvq4w4wwlmz9vk2nb4c2yibpn9rmc6ighn";
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
