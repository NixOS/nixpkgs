{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, lxqt
, qtbase
, qttools
, qtx11extras
, libfm-qt
, menu-cache
, lxmenu-data
, lxqtUpdateScript
}:

mkDerivation rec {
  pname = "pcmanfm-qt";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1awyncpypygsrg7d2nc6xh1l4xaln3ypdliy4xmq8bf94sh9rf0y";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    libfm-qt
    libfm-qt
    menu-cache
    lxmenu-data
  ];

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  postPatch = ''
    substituteInPlace config/pcmanfm-qt/lxqt/settings.conf.in --replace @LXQT_SHARE_DIR@ /run/current-system/sw/share/lxqt
  '';

  meta = with lib; {
    homepage = "https://github.com/lxqt/pcmanfm-qt";
    description = "File manager and desktop icon manager (Qt port of PCManFM and libfm)";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
