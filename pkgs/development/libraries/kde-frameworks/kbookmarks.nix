{
  mkDerivation,
  extra-cmake-modules, qttools,
  kcodecs, kconfig, kconfigwidgets, kcoreaddons, kiconthemes, kwidgetsaddons,
  kxmlgui, qtbase,
}:

mkDerivation {
  pname = "kbookmarks";
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [
    kcodecs kconfig kconfigwidgets kcoreaddons kiconthemes kxmlgui
  ];
  propagatedBuildInputs = [ kwidgetsaddons qtbase ];
  outputs = [ "out" "dev" ];
}
