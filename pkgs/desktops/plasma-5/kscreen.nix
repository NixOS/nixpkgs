{ mkDerivation, extra-cmake-modules, kconfig, kconfigwidgets
, kdbusaddons, kglobalaccel, ki18n, kwidgetsaddons, kxmlgui
, libkscreen, qtdeclarative, qtgraphicaleffects
}:

mkDerivation {
  name = "kscreen";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kglobalaccel ki18n libkscreen qtdeclarative qtgraphicaleffects kconfig
    kconfigwidgets kdbusaddons kwidgetsaddons kxmlgui
  ];
}
