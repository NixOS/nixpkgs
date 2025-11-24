{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qtbase,
  qttools,
  lxqt-build-tools,
  wrapQtAppsHook,
  gitUpdater,
  version ? "2.3.0",
}:

stdenv.mkDerivation rec {
  pname = "qtermwidget";
  inherit version;

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "qtermwidget";
    rev = version;
    hash =
      {
        "1.4.0" = "sha256-wYUOqAiBjnupX1ITbFMw7sAk42V37yDz9SrjVhE4FgU=";
        "2.3.0" = "sha256-l+IFXiUst9PDNuD/KGzxYCUjymhWvcpMY9CF60gIfKg=";
      }
      ."${version}";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  passthru.updateScript = gitUpdater { };

  postPatch = lib.optionals (version == "1.4.0") ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/lxqt/qtermwidget";
    description = "Terminal emulator widget for Qt, used by QTerminal";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    teams = [ teams.lxqt ];
  };
}
