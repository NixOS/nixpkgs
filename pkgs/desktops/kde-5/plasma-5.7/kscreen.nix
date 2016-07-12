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
  propagatedBuildInputs = [
    kglobalaccel ki18n libkscreen qtdeclarative qtgraphicaleffects kconfig
    kconfigwidgets kdbusaddons kwidgetsaddons kxmlgui
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kscreen-console"
  '';
}
