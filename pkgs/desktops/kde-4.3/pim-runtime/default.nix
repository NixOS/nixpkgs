{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost, shared_mime_info
, kdelibs, kdelibs_experimental, kdepimlibs
, automoc4, phonon, akonadi, soprano, strigi}:

stdenv.mkDerivation {
  name = "kdepim-runtime-4.3.3";
  src = fetchurl {
    url = mirror://kde/stable/4.3.3/src/kdepim-runtime-4.3.3.tar.bz2;
    sha1 = "cqgavixw2hljdx2afxdrg9k4zipp44rc";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost shared_mime_info
                  kdelibs kdelibs_experimental kdepimlibs
		  automoc4 phonon akonadi soprano strigi ];
  CMAKE_PREFIX_PATH=kdepimlibs;
  includeAllQtDirs=true;
  builder = ./builder.sh;
  meta = {
    description = "KDE PIM runtime";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
