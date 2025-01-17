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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "matinlotfali";
    repo = "KDE-Rounded-Corners";
    rev = "v${version}";
    hash = "sha256-6uSgYFY+JV8UCy3j9U/hjk6wJpD1XqpnXBqmKVi/2W0=";
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
