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

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/lxqt/compton-conf";
    description = "GUI configuration tool for compton X composite manager";
    mainProgram = "compton-conf";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    teams = [ teams.lxqt ];
  };
}
