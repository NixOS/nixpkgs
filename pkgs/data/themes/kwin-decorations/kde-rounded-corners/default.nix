{
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  wrapQtAppsHook,
  qtbase,
  kwin,
  kcmutils,
  libepoxy,
  libxcb,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "kde-rounded-corners";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "matinlotfali";
    repo = "KDE-Rounded-Corners";
    rev = "v${version}";
    hash = "sha256-ef63PVG0JOHY4zyq5M5oAAcxtfhm1XOvpsxgSeXvgDo=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];
  buildInputs = [
    kcmutils
    kwin
    libepoxy
    libxcb
    qtbase
  ];

  meta = with lib; {
    description = "Rounds the corners of your windows";
    homepage = "https://github.com/matinlotfali/KDE-Rounded-Corners";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ devusb ];
  };
}
