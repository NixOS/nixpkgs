{
  mkDerivation,
  lib,
  fetchurl,
  extra-cmake-modules,
  qtbase,
  kconfig,
  kcoreaddons,
  kwidgetsaddons,
  kguiaddons,
  qttools,
}:

mkDerivation rec {
  pname = "kproperty";
  version = "3.2.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/src/${pname}-${version}.tar.xz";
    sha256 = "1yldfsdamk4dag8dyryjn5n9j2pzi42s79kkafymfnbifhnhrbv7";
  };

  patches = [
    ./cmake-minimum-required.patch
  ];

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [
    kconfig
    kcoreaddons
    kwidgetsaddons
    kguiaddons
    qttools
  ];

  propagatedBuildInputs = [ qtbase ];

<<<<<<< HEAD
  meta = {
    description = "Property editing framework with editor widget similar to what is known from Qt Designer";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zraexy ];
=======
  meta = with lib; {
    description = "Property editing framework with editor widget similar to what is known from Qt Designer";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zraexy ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
