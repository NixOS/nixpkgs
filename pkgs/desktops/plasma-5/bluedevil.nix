{
  plasmaPackage, extra-cmake-modules, shared_mime_info,
  bluez-qt, kcoreaddons, kdbusaddons, kded, ki18n, kiconthemes, kio,
  knotifications, kwidgetsaddons, kwindowsystem, plasma-framework, qtdeclarative
}:

plasmaPackage {
  name = "bluedevil";
  nativeBuildInputs = [ extra-cmake-modules shared_mime_info ];
  propagatedBuildInputs = [
    bluez-qt ki18n kio kwindowsystem plasma-framework qtdeclarative kcoreaddons
    kdbusaddons kded kiconthemes knotifications kwidgetsaddons
  ];
  propagatedUserEnvPkgs = [ bluez-qt.out ];
  postInstall = ''
    # Fix the location of logic.js for the plasmoid
    ln -s $out/share/plasma/plasmoids/org.kde.plasma.bluetooth/contents/code/logic.js $out/share/plasma/plasmoids/org.kde.plasma.bluetooth/contents/ui/logic.js
  '';
}
