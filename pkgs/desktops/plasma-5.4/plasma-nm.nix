{ plasmaPackage
, extra-cmake-modules
, kdoctools
, kcompletion
, kconfigwidgets
, kcoreaddons
, kdbusaddons
, kdeclarative
, kdelibs4support
, ki18n
, kiconthemes
, kinit
, kio
, kitemviews
, knotifications
, kservice
, kwallet
, kwidgetsaddons
, kwindowsystem
, kxmlgui
, mobile_broadband_provider_info
, modemmanager-qt
, networkmanager-qt
, openconnect
, plasma-framework
, qtdeclarative
, solid
}:

plasmaPackage {
  name = "plasma-nm";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcompletion
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    kdeclarative
    kdelibs4support
    ki18n
    kiconthemes
    kinit
    kio
    kitemviews
    knotifications
    kservice
    kwallet
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    mobile_broadband_provider_info
    modemmanager-qt
    networkmanager-qt
    openconnect
    plasma-framework
    qtdeclarative
    solid
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kde5-nm-connection-editor"
  '';
}
