{ plasmaPackage, extra-cmake-modules, bluez-qt, kcoreaddons
, kdbusaddons, kded, ki18n, kiconthemes, kio, knotifications
, kwidgetsaddons, kwindowsystem, plasma-framework, qtdeclarative
, shared_mime_info
}:

plasmaPackage {
  name = "bluedevil";
  nativeBuildInputs = [ extra-cmake-modules shared_mime_info ];
  buildInputs = [
    kcoreaddons kdbusaddons kded kiconthemes knotifications
    kwidgetsaddons
  ];
  propagatedBuildInputs = [
    baloo bluez-qt ki18n kio kwindowsystem plasma-framework qtdeclarative
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/bluedevil-wizard"
    wrapKDEProgram "$out/bin/bluedevil-sendfile"
  '';
}
