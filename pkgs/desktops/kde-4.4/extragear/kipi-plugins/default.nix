{ stdenv, fetchurl, lib, cmake, qt4, kdelibs, automoc4, phonon, qimageblitz, qca2,
kdegraphics, kdepimlibs, libxml2, libxslt, gettext}:

stdenv.mkDerivation rec {
  name = "kipi-plugins-1.3.0";

  src = fetchurl { 
    url = "mirror://sourceforge/kipi/${name}.tar.bz2";
    sha256 = "13cwhgqc8c0kxxaa8lsw8xibdpsgxcgngsy2m5c4y4rk6rh8fx0x";
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
