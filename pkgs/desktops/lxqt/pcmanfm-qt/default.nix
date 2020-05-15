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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "16zwd2jfrmsnzfpywirkrpyilq1jj99liwvg77l20b1dbql9dc0q";
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

  meta = with lib; {
    description = "File manager and desktop icon manager (Qt port of PCManFM and libfm)";
    homepage = "https://github.com/lxqt/pcmanfm-qt";
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
