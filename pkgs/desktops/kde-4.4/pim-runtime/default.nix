{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost, shared_mime_info
, kdelibs, kdepimlibs
, automoc4, phonon, akonadi, soprano, strigi}:

stdenv.mkDerivation {
  name = "kdepim-runtime-4.4.2";
  src = fetchurl {
    url = mirror://kde/stable/4.4.2/src/kdepim-runtime-4.4.2.tar.bz2;
    sha256 = "05baz0wslxyvdilwj1lx9gg77xh51pa5ah91855vkfsjlc0qzvcs";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost shared_mime_info
                  kdelibs kdepimlibs
		  automoc4 phonon akonadi soprano strigi ];
  builder = ./builder.sh;
  meta = {
    description = "KDE PIM runtime";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
