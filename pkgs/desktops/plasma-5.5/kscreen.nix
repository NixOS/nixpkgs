{ plasmaPackage, extra-cmake-modules, kconfig, kconfigwidgets
, kdbusaddons, kglobalaccel, ki18n, kwidgetsaddons, kxmlgui
, libkscreen, makeQtWrapper, qtdeclarative, qtgraphicaleffects
}:

plasmaPackage {
  name = "kscreen";
  nativeBuildInputs = [
    extra-cmake-modules
    makeQtWrapper
  ];
  buildInputs = [
    kconfig
    kconfigwidgets
    kdbusaddons
    kwidgetsaddons
    kxmlgui
  ];
  propagatedBuildInputs = [
    kglobalaccel
    ki18n
    libkscreen
    qtdeclarative
    qtgraphicaleffects
  ];
  propagatedUserEnvPkgs = [
    libkscreen  # D-Bus service
    qtdeclarative  # QML import
    qtgraphicaleffects  # QML import
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kscreen-console"
  '';
}
