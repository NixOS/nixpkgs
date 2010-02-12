{ stdenv, fetchurl, lib, cmake, qt4, perl, libxml2, libxslt, boost, shared_mime_info
, kdelibs, kdelibs_experimental, kdepimlibs
, automoc4, phonon, akonadi, soprano, strigi}:

stdenv.mkDerivation {
  name = "kdepim-runtime-4.3.4";
  src = fetchurl {
    url = mirror://kde/stable/4.3.4/src/kdepim-runtime-4.3.4.tar.bz2;
    sha1 = "bef70088aec4355f5bb8c0375082388eaa3d4b26";
  };
  buildInputs = [ cmake qt4 perl libxml2 libxslt boost shared_mime_info
                  kdelibs kdelibs_experimental kdepimlibs
		  automoc4 phonon akonadi soprano strigi ];
  CMAKE_PREFIX_PATH=kdepimlibs;
  builder = ./builder.sh;
  meta = {
    description = "KDE PIM runtime";
    homepage = http://www.kde.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
