{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  layer-shell-qt,
  libexif,
  libfm-qt,
  lxqt-build-tools,
  lxqt-menu-data,
  menu-cache,
  pkg-config,
  qtbase,
  qtimageformats,
  qttools,
  qtwayland,
  qtsvg,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "pcmanfm-qt";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-PyCtcn+QHwX/iy85A3y7Phf8ogdSRrwtXrJYGxrjyLM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    layer-shell-qt
    libexif
    libfm-qt
    lxqt-menu-data
    menu-cache
    qtbase
    qtimageformats # add-on module to support more image file formats
    qtwayland
    qtsvg
  ];

  passthru.updateScript = gitUpdater { };

  postPatch = ''
    substituteInPlace config/pcmanfm-qt/lxqt/settings.conf.in --replace-fail @LXQT_SHARE_DIR@ /run/current-system/sw/share/lxqt
  '';

  meta = with lib; {
    homepage = "https://github.com/lxqt/pcmanfm-qt";
    description = "File manager and desktop icon manager (Qt port of PCManFM and libfm)";
    mainProgram = "pcmanfm-qt";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
