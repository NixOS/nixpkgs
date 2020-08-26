{
  mkDerivation,
  extra-cmake-modules,
  kconfig, kcmutils, kconfigwidgets, kdbusaddons, kglobalaccel, ki18n,
  kwidgetsaddons, kxmlgui, libkscreen, qtdeclarative, qtgraphicaleffects,
  kwindowsystem, kdeclarative, plasma-framework
}:

mkDerivation {
  name = "kscreen";
  patches = [ ./kscreen-417316.patch ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kconfig kcmutils kconfigwidgets kdbusaddons kglobalaccel ki18n
    kwidgetsaddons kxmlgui libkscreen qtdeclarative qtgraphicaleffects
    kwindowsystem kdeclarative plasma-framework
  ];
}
