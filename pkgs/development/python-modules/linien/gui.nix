{ callPackage
, click
, paramiko
, pyqtgraph
, pyqt5
, qt5
, superqt
, linien-client
, appdirs
}:

callPackage ./common.nix {
  propagatedBuildInputs = [
    click
    paramiko
    pyqtgraph
    pyqt5
    superqt
    linien-client
    appdirs
  ];
  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';
} "GUI"
