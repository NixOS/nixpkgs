{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost, shared_mime_info
, kdelibs, kdepimlibs
, automoc4, phonon, akonadi, soprano, strigi}:

stdenv.mkDerivation {
  name = "kdepim-runtime-4.4.5";
  src = fetchurl {
    url = mirror://kde/stable/4.4.5/src/kdepim-runtime-4.4.5.tar.bz2;
    sha256 = "1yisz7vfj51l4hs4f0ry0shas5r7m7p0iqr1458yasad9icq94j7";
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
