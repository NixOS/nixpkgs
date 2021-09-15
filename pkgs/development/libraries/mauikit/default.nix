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
}:

mkDerivation rec {
  pname = "mauikit";
  version = "2.0.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "mauikit";
    rev = "v${version}";
    sha256 = "sha256-qz/MePMvyGR8lzR2xB2f9QENx04UHu0Xef7v0xcKovo=";
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
  ];

  meta = with lib; {
    homepage = "https://mauikit.org/";
    description = "Free and modular front-end framework for developing fast and compelling user experiences";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
    broken = versionOlder qtbase.version "5.15.0";
  };
}
