{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, kwindowsystem
, libfm-qt
, lxqt-qtplugin
, qtx11extras
, lxqtUpdateScript
, extraQtStyles ? []
}:

mkDerivation rec {
  pname = "xdg-desktop-portal-lxqt";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "15wld2p07sbf2i2qv86ljm479q0nr9r65wavmabmn3fkzkz5vlgf";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    kwindowsystem
    libfm-qt
    lxqt-qtplugin
    qtx11extras
  ]
  ++ extraQtStyles;

  passthru.updateScript = lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/xdg-desktop-portal-lxqt";
    description = "Backend implementation for xdg-desktop-portal that is using Qt/KF5/libfm-qt";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
