{
  mkDerivation, substituteAll,
  extra-cmake-modules, kdoctools,
  kcompletion, kconfigwidgets, kcoreaddons, kdbusaddons, kdeclarative,
  kdelibs4support, ki18n, kiconthemes, kinit, kio, kitemviews, knotifications,
  kservice, kwallet, kwidgetsaddons, kwindowsystem, kxmlgui,
  mobile-broadband-provider-info, modemmanager-qt, networkmanager-qt,
  openconnect, openvpn, plasma-framework, qca-qt5, qtdeclarative, qttools, solid
}:

mkDerivation {
  name = "plasma-nm";
  nativeBuildInputs = [ extra-cmake-modules kdoctools qttools ];
  buildInputs = [
    kdeclarative kdelibs4support ki18n kio kwindowsystem plasma-framework
    qtdeclarative kcompletion kconfigwidgets kcoreaddons kdbusaddons kiconthemes
    kinit kitemviews knotifications kservice kwallet kwidgetsaddons kxmlgui
    mobile-broadband-provider-info modemmanager-qt networkmanager-qt openconnect
    qca-qt5 solid
  ];
  patches = [
    (substituteAll {
      src = ./0001-mobile-broadband-provider-info-path.patch;
      inherit mobile-broadband-provider-info;
    })
    (substituteAll {
      src = ./0002-openvpn-binary-path.patch;
      inherit openvpn;
    })
  ];
}
