{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost, shared_mime_info
, kdelibs, kdelibs_experimental, kdepimlibs
, automoc4, phonon, akonadi, soprano, strigi}:

stdenv.mkDerivation {
  name = "kdepim-runtime-4.3.2";
  src = fetchurl {
    url = mirror://kde/stable/4.3.2/src/kdepim-runtime-4.3.2.tar.bz2;
    sha1 = "j46sbwxqrdwzcr3bxxxaja2phjrg8q90";
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
