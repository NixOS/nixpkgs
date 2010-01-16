{ stdenv, fetchurl, lib, cmake, qt4, kdelibs, automoc4, phonon, qimageblitz, qca2, eigen,
kdegraphics, lcms, jasper, libgphoto2, kdepimlibs, gettext}:

stdenv.mkDerivation {
  name = "digikam-1.0.0";

  src = fetchurl { 
    url = mirror://sourceforge/digikam/digikam-1.0.0.tar.bz2;
    sha256 = "0qblqyjn0vas8hyqn5s9rr401d93cagk53y3j8kch0mr0bk706bk";
  };

  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 kdelibs kdegraphics automoc4 phonon qimageblitz qca2 eigen
    lcms jasper libgphoto2 kdepimlibs gettext ];
  CMAKE_PREFIX_PATH = kdepimlibs;
  cmakeFlags = [ "-DGETTEXT_INCLUDE_DIR=${gettext}/include" ];
  meta = {
    description = "Photo Management Program";
    license = "GPL";
    homepage = http://www.koffice.org;
    maintainers = [ lib.maintainers.viric ];
    platforms = with lib.platforms; linux;
  };
}
