{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, kconfig
, kcoreaddons
, ki18n
, knotifications
, qtbase
, qtquickcontrols2
, qtx11extras
}:

mkDerivation rec {
  pname = "mauikit";
  version = "2.1.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "mauikit";
    rev = "master"; 
    #rev = "v${version}";
    sha256 = "sha256-uatsvO/YiYCa5IqYR5sufwgiKi/PaKN66fVB0Ao49uA=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kcoreaddons
    ki18n
    knotifications
    qtquickcontrols2
    qtx11extras
  ];

  meta = with lib; {
    homepage = "https://mauikit.org/";
    description = "Free and modular front-end framework for developing fast and compelling user experiences";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
    broken = versionOlder qtbase.version "5.15.0";
  };
}
