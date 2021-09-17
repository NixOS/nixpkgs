{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, kconfig
, kcoreaddons
, ki18n
, qtbase
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "mauikit";
  version = "1.2.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "mauikit";
    rev = "v${version}";
    sha256 = "1jz0a65bbznjg7aaq19rdyp956wn6xc1x4xigfkhj6mwsvnb49av";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kcoreaddons
    ki18n
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
