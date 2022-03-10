{
  mkDerivation,
  extra-cmake-modules,
  kconfig, kcmutils, kconfigwidgets, kdbusaddons, kglobalaccel, ki18n,
  kwidgetsaddons, kxmlgui, libkscreen, qtdeclarative, qtgraphicaleffects, qtsensors,
  kwindowsystem, kdeclarative, plasma-framework
}:

mkDerivation {
  pname = "kscreen";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kconfig kcmutils kconfigwidgets kdbusaddons kglobalaccel ki18n
    kwidgetsaddons kxmlgui libkscreen qtdeclarative qtgraphicaleffects qtsensors
    kwindowsystem kdeclarative plasma-framework
  ];
}
