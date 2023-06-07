{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, libexif
, lxqt
, qtbase
, qttools
, qtx11extras
, qtimageformats
, libfm-qt
, menu-cache
, lxmenu-data
, gitUpdater
}:

mkDerivation rec {
  pname = "pcmanfm-qt";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "qqvjsZRG+ImKHr+XLNNHhnAe1kBWh47/nFcKB1MTSJo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    libexif
    qtbase
    qttools
    qtx11extras
    qtimageformats # add-on module to support more image file formats
    libfm-qt
    menu-cache
    lxmenu-data
  ];

  passthru.updateScript = gitUpdater { };

  postPatch = ''
    substituteInPlace config/pcmanfm-qt/lxqt/settings.conf.in --replace @LXQT_SHARE_DIR@ /run/current-system/sw/share/lxqt
  '';

  meta = with lib; {
    homepage = "https://github.com/lxqt/pcmanfm-qt";
    description = "File manager and desktop icon manager (Qt port of PCManFM and libfm)";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
