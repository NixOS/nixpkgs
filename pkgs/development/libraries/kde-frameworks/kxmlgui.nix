{
  mkDerivation, lib,
  extra-cmake-modules, qttools,
  attica, kconfig, kconfigwidgets, kglobalaccel, ki18n, kiconthemes, kitemviews,
  ktextwidgets, kwindowsystem, qtbase, sonnet,
}:

mkDerivation {
  name = "kxmlgui";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    attica kglobalaccel ki18n kiconthemes kitemviews ktextwidgets kwindowsystem
    sonnet
  ];
  propagatedBuildInputs = [ kconfig kconfigwidgets qtbase qttools ];
}
