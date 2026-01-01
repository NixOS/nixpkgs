{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libconfig,
  lxqt-build-tools,
  pkg-config,
  qtbase,
  qttools,
  qtx11extras,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "compton-conf";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "compton-conf";
    rev = version;
    hash = "sha256-GNS0GdkQOEFQHCeXFVNDdT35KCRhfwmkL78tpY71mz0=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    pkg-config
    qttools
    qtx11extras
    wrapQtAppsHook
  ];

  buildInputs = [
    libconfig
    qtbase
  ];

  preConfigure = ''
    substituteInPlace autostart/CMakeLists.txt \
      --replace-fail "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg" \
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  passthru.updateScript = gitUpdater { };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/lxqt/compton-conf";
    description = "GUI configuration tool for compton X composite manager";
    mainProgram = "compton-conf";
<<<<<<< HEAD
    license = lib.licenses.lgpl21Plus;
    platforms = with lib.platforms; unix;
    teams = [ lib.teams.lxqt ];
=======
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    teams = [ teams.lxqt ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
