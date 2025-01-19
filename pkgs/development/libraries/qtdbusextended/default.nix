{
  stdenv,
  lib,
  fetchFromGitHub,
  qmake,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "qtdbusextended";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "nemomobile";
    repo = pname;
    rev = version;
    sha256 = "sha256-tUp7OhNBXwomR2tO4UOaR0vJQ3GTirMk/hRl1cMk61o=";
  };

  postPatch = ''
    substituteInPlace src/src.pro \
      --replace '$$[QT_INSTALL_LIBS]' "$out/lib" \
      --replace '$$[QT_INSTALL_HEADERS]' "$out/include" \
      --replace '$$[QMAKE_MKSPECS]' "$out/mkspecs"
  '';

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  meta = {
    description = "Qt provides several classes for DBus communication";
    homepage = "https://github.com/nemomobile/qtdbusextended";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rewine ];
  };
}
