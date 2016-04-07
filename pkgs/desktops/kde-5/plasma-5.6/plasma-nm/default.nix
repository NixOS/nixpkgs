{ plasmaPackage, substituteAll, extra-cmake-modules, kdoctools
, kcompletion, kconfigwidgets, kcoreaddons, kdbusaddons, kdeclarative
, kdelibs4support, ki18n, kiconthemes, kinit, kio, kitemviews
, knotifications, kservice, kwallet, kwidgetsaddons, kwindowsystem
, kxmlgui, makeQtWrapper, mobile_broadband_provider_info
, modemmanager-qt, networkmanager-qt, openconnect, plasma-framework
, qca-qt5, qtdeclarative, solid
}:

plasmaPackage {
  name = "plasma-nm";
  patches = [
    (substituteAll {
      src = ./0001-mobile-broadband-provider-info-path.patch;
      inherit mobile_broadband_provider_info;
    })
  ];
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];
  buildInputs = [
    kcompletion kconfigwidgets kcoreaddons kdbusaddons kiconthemes
    kinit kitemviews knotifications kservice kwallet kwidgetsaddons
    kxmlgui mobile_broadband_provider_info modemmanager-qt
    networkmanager-qt openconnect qca-qt5 solid
  ];
  propagatedBuildInputs = [
    kdeclarative kdelibs4support ki18n kio kwindowsystem plasma-framework
    qtdeclarative
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kde5-nm-connection-editor"
  '';
}
