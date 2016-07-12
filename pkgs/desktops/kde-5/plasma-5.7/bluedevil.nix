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
  propagatedBuildInputs = [
    bluez-qt ki18n kio kwindowsystem plasma-framework qtdeclarative kcoreaddons
    kdbusaddons kded kiconthemes knotifications kwidgetsaddons
  ];
  propagatedUserEnvPkgs = [ bluez-qt ];
  postInstall = ''
    wrapQtProgram "$out/bin/bluedevil-wizard"
    wrapQtProgram "$out/bin/bluedevil-sendfile"
    # Fix the location of logic.js for the plasmoid
    ln -s $out/share/plasma/plasmoids/org.kde.plasma.bluetooth/contents/code/logic.js $out/share/plasma/plasmoids/org.kde.plasma.bluetooth/contents/ui/logic.js
  '';
}
