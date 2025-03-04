{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  qt6Packages,
  dtk6widget,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "deepin-picker";
  version = "6.0.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-TeUhDEldte5PJJe1l0q4wUTnnaXY052YP1JAhpLz/sA=";
  };

  nativeBuildInputs = [
    qt6Packages.qmake
    qt6Packages.qttools
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.qtbase
    dtk6widget
    qt6Packages.qtsvg
    xorg.libXtst
  ];

  postPatch = ''
    substituteInPlace com.deepin.Picker.service \
      --replace "/usr/bin/deepin-picker" "$out/bin/deepin-picker"
  '';

  qmakeFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "ICONDIR=${placeholder "out"}/share/icons/hicolor/scalable/apps"
    "APPDIR=${placeholder "out"}/share/applications"
    "DSRDIR=${placeholder "out"}/share/deepin-picker"
    "DOCDIR=${placeholder "out"}/share/dman/deepin-picker"
  ];

  meta = {
    description = "Color picker application";
    mainProgram = "deepin-picker";
    homepage = "https://github.com/linuxdeepin/deepin-picker";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
