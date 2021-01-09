{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "09mlv5qkwzpfz5l41pcz0k01kgsikzkghhfkl84hwyjdm4i2vapj";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
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
    description = "File manager and desktop icon manager (Qt port of PCManFM and libfm)";
    homepage = "https://github.com/lxqt/pcmanfm-qt";
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
