{
  mkDerivation, lib, substituteAll,
  extra-cmake-modules, kdoctools,
  kcompletion, kconfigwidgets, kcoreaddons, kdbusaddons, kdeclarative,
  kdelibs4support, ki18n, kiconthemes, kinit, kio, kitemviews, knotifications,
  kservice, kwallet, kwidgetsaddons, kwindowsystem, kxmlgui,
  mobile-broadband-provider-info, modemmanager-qt, networkmanager-qt,
  openconnect, openvpn, plasma-framework, qca-qt5, qtbase, qtdeclarative,
  qttools, solid
}:

mkDerivation {
  name = "plasma-nm";
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
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
      mobile_broadband_provider_info = mobile-broadband-provider-info;
    })
    (substituteAll {
      src = ./0002-openvpn-binary-path.patch;
      inherit openvpn;
    })
  ];
}
