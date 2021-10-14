{
  mkDerivation,
  extra-cmake-modules,
  kconfig, kcmutils, kconfigwidgets, kdbusaddons, kglobalaccel, ki18n,
  kwidgetsaddons, kxmlgui, libkscreen, qtdeclarative, qtgraphicaleffects, qtsensors,
  kwindowsystem, kdeclarative, plasma-framework, wayland-scanner, wayland
}:

mkDerivation {
  name = "kscreen";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kconfig kcmutils kconfigwidgets kdbusaddons kglobalaccel ki18n
    kwidgetsaddons kxmlgui libkscreen qtdeclarative qtgraphicaleffects qtsensors
    kwindowsystem kdeclarative plasma-framework wayland-scanner wayland
  ];
}
