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
  tzdata,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-admin";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-admin";
    rev = version;
    hash = "sha256-Yne4EWP/bgWXa4XNP8oyUtkOfxBRcT4iuV8CpSq2ooY=";
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

  cmakeFlags = [
    # fake finding of libsystemd; used to check if we are a systemd-based
    # distro rather than actually being linked to
    "-DLIBSYSTEMD_FOUND=TRUE"
  ];

  postPatch = ''
    for f in lxqt-admin-{time,user}/CMakeLists.txt; do
      substituteInPlace $f --replace-fail \
        "\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR}" \
        "$out/share/polkit-1/actions"
    done

    # patch timezone database file location
    substituteInPlace lxqt-admin-time/timeadmindialog.cpp \
      --replace-fail "/usr/share/zoneinfo/zone.tab" "${tzdata}/share/zoneinfo/zone.tab"
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-admin";
    description = "LXQt system administration tool";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.lxqt ];
  };
}
