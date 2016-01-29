{ plasmaPackage, extra-cmake-modules, bluez-qt, kcoreaddons
, kdbusaddons, kded, ki18n, kiconthemes, kio, knotifications
, kwidgetsaddons, kwindowsystem, makeQtWrapper, plasma-framework
, qtdeclarative, shared_mime_info
}:

plasmaPackage {
  name = "bluedevil";
  nativeBuildInputs = [
    extra-cmake-modules makeQtWrapper shared_mime_info
  ];
  buildInputs = [
    kcoreaddons kdbusaddons kded kiconthemes knotifications
    kwidgetsaddons
  ];
  propagatedBuildInputs = [
    bluez-qt ki18n kio kwindowsystem plasma-framework qtdeclarative
  ];
  propagatedUserEnvPkgs = [ bluez-qt ];
  postInstall = ''
    wrapQtProgram "$out/bin/bluedevil-wizard"
    wrapQtProgram "$out/bin/bluedevil-sendfile"
  '';
}
