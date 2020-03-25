{
  mkDerivation,
  extra-cmake-modules,
  kconfig, kcmutils, kconfigwidgets, kdbusaddons, kglobalaccel, ki18n,
  kwidgetsaddons, kxmlgui, libkscreen, qtdeclarative, qtgraphicaleffects,
  kwindowsystem, kdeclarative, plasma-framework, qtsensors
}:

mkDerivation {
  name = "kscreen";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kconfig kcmutils kconfigwidgets kdbusaddons kglobalaccel ki18n
    kwidgetsaddons kxmlgui libkscreen qtdeclarative qtgraphicaleffects
    kwindowsystem kdeclarative plasma-framework qtsensors
  ];
}
