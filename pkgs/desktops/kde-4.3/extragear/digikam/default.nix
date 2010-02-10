{ stdenv, fetchurl, lib, cmake, qt4, kdelibs, automoc4, phonon, qimageblitz, qca2, eigen,
kdegraphics, lcms, jasper, libgphoto2, kdepimlibs, gettext}:

stdenv.mkDerivation rec {
  name = "digikam-1.1.0";

  src = fetchurl { 
    url = "mirror://sourceforge/digikam/${name}.tar.bz2";
    sha256 = "13zs5gwrzmqcx29r4vn96csz5hivycczjpa5l1157f5xhcg949kd";
  };

  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 kdelibs kdegraphics automoc4 phonon qimageblitz qca2 eigen
    lcms jasper libgphoto2 kdepimlibs gettext ];
  CMAKE_PREFIX_PATH = kdepimlibs;
  cmakeFlags = [ "-DGETTEXT_INCLUDE_DIR=${gettext}/include" ];
  meta = {
    description = "Photo Management Program";
    license = "GPL";
    homepage = http://www.digikam.org;
    maintainers = [ lib.maintainers.viric ];
    platforms = with lib.platforms; linux;
  };
}
