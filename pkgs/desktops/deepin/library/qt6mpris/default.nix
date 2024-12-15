{
  stdenv,
  lib,
  fetchFromGitHub,
  qt6Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qt6mpris";
  version = "1.0.0.1-1deepin1";

  src = fetchFromGitHub {
    owner = "deepin-community";
    repo = "qt6mpris";
    rev = finalAttrs.version;
    hash = "sha256-PCdA9q/txaL2Fbr2/4+Z7L4zxWeULl3bq8MVH3i1g3g=";
  };

  postPatch = ''
    substituteInPlace src/src.pro \
      --replace-fail '$$[QT_INSTALL_LIBS]'    "$out/lib" \
      --replace-fail '$$[QT_INSTALL_HEADERS]' "$out/include" \
      --replace-fail '$$[QMAKE_MKSPECS]'      "$out/mkspecs"
    substituteInPlace declarative/declarative.pro \
      --replace-fail '$$[QT_INSTALL_QML]'     "$out/${qt6Packages.qtbase.qtQmlPrefix}"
  '';

  nativeBuildInputs = [
    qt6Packages.qmake
  ];

  dontWrapQtApps = true;

  buildInputs = [
    qt6Packages.qtbase
    qt6Packages.qtdeclarative
  ];

  meta = {
    description = "Qt and QML MPRIS interface and adaptor";
    homepage = "https://github.com/deepin-community/qt6mpris";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
})
