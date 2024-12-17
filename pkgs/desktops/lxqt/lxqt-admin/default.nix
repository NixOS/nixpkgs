{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  polkit-qt-1,
  qtsvg,
  qttools,
  qtwayland,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-admin";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-7RyPUv/M8mMoRO+SopFuru+bY9ZwnKz2BkiLz1cW/wg=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    liblxqt
    libqtxdg
    polkit-qt-1
    qtsvg
    qtwayland
  ];

  postPatch = ''
    for f in lxqt-admin-{time,user}/CMakeLists.txt; do
      substituteInPlace $f --replace-fail \
        "\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR}" \
        "$out/share/polkit-1/actions"
    done
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-admin";
    description = "LXQt system administration tool";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
