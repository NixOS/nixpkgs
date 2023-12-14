{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, libexif
, lxqt-build-tools
, lxqt-menu-data
, qtbase
, qttools
, qtx11extras
, qtimageformats
, libfm-qt
, menu-cache
, gitUpdater
}:

mkDerivation rec {
  pname = "pcmanfm-qt";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-+U8eV6oDpaJfTzejsVtbcaQrfSjWUnVpnIDbkvVCY/c=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
  ];

  buildInputs = [
    libexif
    lxqt-menu-data
    qtbase
    qtx11extras
    qtimageformats # add-on module to support more image file formats
    libfm-qt
    menu-cache
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
