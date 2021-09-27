{
  mkDerivation, lib, substituteAll,
  extra-cmake-modules, kdoctools,
  kcompletion, kconfigwidgets, kcoreaddons, kdbusaddons, kdeclarative,
  ki18n, kiconthemes, kinit, kio, kitemviews, knotifications, kservice, kwallet,
  kwidgetsaddons, kwindowsystem, kxmlgui, plasma-framework, prison, solid,

  mobile-broadband-provider-info, openconnect, openvpn,
  modemmanager-qt, networkmanager-qt, qca-qt5,
  qtbase, qtdeclarative, qttools,
}:

mkDerivation {
  name = "plasma-nm";
  nativeBuildInputs = [ extra-cmake-modules kdoctools qttools ];
  buildInputs = [
    kdeclarative ki18n kio kwindowsystem plasma-framework kcompletion
    kconfigwidgets kcoreaddons kdbusaddons kiconthemes
    kinit kitemviews knotifications kservice kwallet kwidgetsaddons kxmlgui
    prison solid

    qtdeclarative
    modemmanager-qt networkmanager-qt qca-qt5
    mobile-broadband-provider-info openconnect
  ];
  patches = [
    (substituteAll {
      src = ./0002-openvpn-binary-path.patch;
      inherit openvpn;
    })
  ];
}
