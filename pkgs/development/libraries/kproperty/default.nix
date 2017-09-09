{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules,
  qtbase, kconfig, kcoreaddons, kwidgetsaddons, kguiaddons
}:

mkDerivation rec {
  pname = "kproperty";
  version = "3.0.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/src/${name}.tar.xz";
    sha256 = "1hzkvdap7dzpnxlp4rfg5f24fhqjpqm2hlvv88gj4c0scbp73ynm";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [ kconfig kcoreaddons kwidgetsaddons kguiaddons ];

  propagatedBuildInputs = [ qtbase ];

  meta = with lib; {
    description = "A property editing framework with editor widget similar to what is known from Qt Designer";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zraexy ];
  };
}
