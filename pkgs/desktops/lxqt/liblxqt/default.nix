{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gitUpdater,
  kwindowsystem,
  libXScrnSaver,
  libqtxdg,
  lxqt-build-tools,
  polkit-qt-1,
  qtsvg,
  qttools,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "liblxqt";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-90t7jukm2vNfkgZ3326UDMXNzwJ+FIVEF3kNZ2SgNN8=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    libXScrnSaver
    libqtxdg
    polkit-qt-1
    qtsvg
  ];

  # convert name of wrapped binary, e.g. .lxqt-whatever-wrapped to the original name, e.g. lxqt-whatever so binaries can find their resources
  patches = [ ./fix-application-path.patch ];

  postPatch = ''
    # https://github.com/NixOS/nixpkgs/issues/119766
    substituteInPlace lxqtbacklight/linux_backend/driver/libbacklight_backend.c \
      --replace-fail "pkexec lxqt-backlight_backend" "pkexec $out/bin/lxqt-backlight_backend"

    sed -i "s|\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR}|''${out}/share/polkit-1/actions|" CMakeLists.txt
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Core utility library for all LXQt components";
    mainProgram = "lxqt-backlight_backend";
    homepage = "https://github.com/lxqt/liblxqt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
