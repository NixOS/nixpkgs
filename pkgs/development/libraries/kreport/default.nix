{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules,
  qtdeclarative, qtwebkit, kconfig, kcoreaddons, kwidgetsaddons, kguiaddons, kproperty, marble, python2
}:

mkDerivation rec {
  pname = "kreport";
  version = "3.1.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/src/${name}.tar.xz";
    sha256 = "0v7krpfx0isij9wzwam28fqn039i4wcznbplvnvl6hsykdi8ar1v";
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
