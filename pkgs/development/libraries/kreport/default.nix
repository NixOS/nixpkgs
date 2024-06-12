{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules,
  qtdeclarative, qtwebkit, kconfig, kcoreaddons, kwidgetsaddons, kguiaddons, kproperty, marble, python3
}:

mkDerivation rec {
  pname = "kreport";
  version = "3.2.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/src/${pname}-${version}.tar.xz";
    sha256 = "1mycsvkz5rphi9df2i4ch4ykvprd4m76acsdzs3zis2ljrqnsw92";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [ qtdeclarative qtwebkit kconfig kcoreaddons kwidgetsaddons kguiaddons kproperty marble python3 ];

  meta = with lib; {
    description = "Framework for creation and generation of reports in multiple formats";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zraexy ];
  };
}
