{
  stdenv,
  lib,
  pkg-config,
  qmake,
  qtbase,
  qtdeclarative,
  sailfish-access-control,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sailfish-access-control-plugin";
  inherit (sailfish-access-control) version src patches;

  postPatch = ''
    substituteInPlace qt/qt.pro \
      --replace-fail '$$[QT_INSTALL_QML]' '${placeholder "out"}/${qtbase.qtQmlPrefix}'
  '';

  # QMake doesn't handle strictDeps well
  strictDeps = false;

  nativeBuildInputs = [
    pkg-config
    qmake
    qtdeclarative # qmlplugindump
  ];

  buildInputs = [
    qtdeclarative
    sailfish-access-control
  ];

  # Qt plugin
  dontWrapQtApps = true;

  # sourceRoot breaks patches
  preConfigure = ''
    cd qt
  '';

  # Do all configuring now, not during build
  postConfigure = ''
    make qmake_all
  '';

  meta = {
    description = "QML interface for sailfish-access-control";
    inherit (sailfish-access-control.meta)
      homepage
      changelog
      license
      teams
      platforms
      ;
  };
})
