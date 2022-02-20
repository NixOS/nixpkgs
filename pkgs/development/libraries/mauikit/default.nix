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
    rev = "v${version}";
    hash = "sha256-INvh+J484xkAsNGtYdf8NGGpFGp2AG7s9UYESoem3QY=";
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
