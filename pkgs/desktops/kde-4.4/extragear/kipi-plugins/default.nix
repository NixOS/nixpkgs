{ stdenv, fetchurl, lib, cmake, qt4, kdelibs, automoc4, phonon, qimageblitz, qca2,
kdegraphics, kdepimlibs, libxml2, libxslt, gettext}:

stdenv.mkDerivation rec {
  name = "kipi-plugins-1.0.0";

  src = fetchurl { 
    url = "mirror://sourceforge/kipi/${name}.tar.bz2";
    sha256 = "1fmjxl41lvyb6zv8wrg8sz0hb1jjynj2pwisynpbffglnxd09fwf";
  };

  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 kdelibs kdegraphics automoc4 phonon qimageblitz qca2 kdepimlibs 
    libxml2 libxslt gettext ];
  CMAKE_PREFIX_PATH = kdepimlibs;
  cmakeFlags = [ "-DGETTEXT_INCLUDE_DIR=${gettext}/include" ];
  meta = {
    description = "Photo Management Program";
    license = "GPL";
    homepage = http://www.kipi-plugins.org;
    maintainers = [ lib.maintainers.viric ];
    platforms = with lib.platforms; linux;
  };
}
