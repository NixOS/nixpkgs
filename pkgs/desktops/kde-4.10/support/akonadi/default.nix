{ stdenv, fetchurl, cmake, qt4, shared_mime_info, libxslt, boost, automoc4, soprano, sqlite }:

stdenv.mkDerivation rec {
  name = "akonadi-1.9.1";
  
  src = fetchurl {
    url = "mirror://kde/stable/akonadi/src/${name}.tar.bz2";
    sha256 = "1w10kb4m8ri6yi1mii2j0sckj3vq11y6qkzijm3lbh4w0fi4kbjk";
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
