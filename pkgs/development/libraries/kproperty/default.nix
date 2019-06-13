{
  mkDerivation, lib, fetchurl,
  extra-cmake-modules,
  qtbase, kconfig, kcoreaddons, kwidgetsaddons, kguiaddons,
  qttools
}:

mkDerivation rec {
  pname = "kproperty";
  version = "3.2.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/src/${name}.tar.xz";
    sha256 = "1yldfsdamk4dag8dyryjn5n9j2pzi42s79kkafymfnbifhnhrbv7";
  };

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [ kconfig kcoreaddons kwidgetsaddons kguiaddons qttools ];

  propagatedBuildInputs = [ qtbase ];

  meta = with lib; {
    description = "A property editing framework with editor widget similar to what is known from Qt Designer";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zraexy ];
  };
}
