{ plasmaPackage, ecm, kconfig, kconfigwidgets
, kdbusaddons, kglobalaccel, ki18n, kwidgetsaddons, kxmlgui
, libkscreen, qtdeclarative, qtgraphicaleffects
}:

plasmaPackage {
  name = "kscreen";
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    kglobalaccel ki18n libkscreen qtdeclarative qtgraphicaleffects kconfig
    kconfigwidgets kdbusaddons kwidgetsaddons kxmlgui
  ];
}
