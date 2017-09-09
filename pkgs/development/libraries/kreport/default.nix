{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules,
  qtbase, qtdeclarative, qtwebkit, kconfig, kcoreaddons, kwidgetsaddons, kguiaddons, kproperty, marble, python2
}:

mkDerivation rec {
  pname = "kreport";
  version = "3.0.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/src/${name}.tar.xz";
    sha256 = "1zd3vhf26cyp8xrq11awm9pmhnk88ppyc0riyr0gxj8y703ahkp0";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [ qtdeclarative qtwebkit kconfig kcoreaddons kwidgetsaddons kguiaddons kproperty marble python2 ];

  meta = with lib; {
    description = "A framework for creation and generation of reports in multiple formats";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zraexy ];
  };
}
