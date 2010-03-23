{ stdenv, fetchurl, lib, cmake, qt4, kdelibs, automoc4, phonon, qimageblitz, qca2,
kdegraphics, kdepimlibs, libxml2, libxslt, gettext}:

stdenv.mkDerivation rec {
  name = "kipi-plugins-1.1.0";

  src = fetchurl { 
    url = "mirror://sourceforge/kipi/${name}.tar.bz2";
    sha256 = "0vclb906g2jgzfl9f2qapaxcqq412j01yn7686682xx8iwrxm2cy";
  };

  buildInputs = [ cmake qt4 kdelibs kdegraphics automoc4 phonon qimageblitz qca2 kdepimlibs 
    libxml2 libxslt gettext ];
  cmakeFlags = [ "-DGETTEXT_INCLUDE_DIR=${gettext}/include" ];
  meta = {
    description = "Photo Management Program";
    license = "GPL";
    homepage = http://www.kipi-plugins.org;
    maintainers = [ lib.maintainers.viric ];
    platforms = with lib.platforms; linux;
  };
}
