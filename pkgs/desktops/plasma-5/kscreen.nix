{
  mkDerivation,
  extra-cmake-modules,
  kconfig, kconfigwidgets, kdbusaddons, kglobalaccel, ki18n, kwidgetsaddons,
  kxmlgui, libkscreen, qtdeclarative, qtgraphicaleffects
}:

mkDerivation {
  name = "kscreen";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kconfig kconfigwidgets kdbusaddons kglobalaccel ki18n kwidgetsaddons kxmlgui
    libkscreen qtdeclarative qtgraphicaleffects
  ];
}
