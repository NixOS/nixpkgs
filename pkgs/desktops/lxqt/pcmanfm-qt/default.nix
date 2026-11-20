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
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "pcmanfm-qt";
    rev = version;
    hash = "sha256-PhSvyo0Alz7W6SikUOY+E9myDbJBe/wSwDVgH8b8xlA=";
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
    qtbase
    qtimageformats # add-on module to support more image file formats
    qtwayland
    qtsvg
  ];

  passthru.updateScript = gitUpdater { };

  postPatch = ''
    substituteInPlace config/pcmanfm-qt/lxqt/settings.conf.in --replace-fail @LXQT_SHARE_DIR@ /run/current-system/sw/share/lxqt
  '';

  meta = {
    homepage = "https://github.com/lxqt/pcmanfm-qt";
    description = "File manager and desktop icon manager (Qt port of PCManFM and libfm)";
    mainProgram = "pcmanfm-qt";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; unix;
    teams = [ lib.teams.lxqt ];
  };
}
