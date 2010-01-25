{ stdenv, fetchurl, lib, cmake, qt4, kdelibs, automoc4, phonon, qimageblitz, qca2,
kdegraphics, kdepimlibs, libxml2, libxslt, gettext}:

stdenv.mkDerivation {
  name = "kipi-plugins-0.9.0";

  src = fetchurl { 
    url = mirror://sourceforge/kipi/kipi-plugins-0.9.0.tar.bz2;
    sha256 = "0wx1r607q8i4v55k8qjzz7wn8rfd86nniq3h3s7dgnddq7x17fqn";
  };

  includeAllQtDirs=true;
  buildInputs = [ cmake qt4 kdelibs kdegraphics automoc4 phonon qimageblitz qca2 kdepimlibs 
    libxml2 libxslt gettext ];
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
