{
  mkDerivation, extra-cmake-modules,
  kauth, kcodecs, kconfig, kdoctools, kguiaddons, ki18n, kwidgetsaddons, qttools, qtbase,
}:

mkDerivation {
  pname = "kconfigwidgets";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kguiaddons ki18n qtbase qttools ];
  propagatedBuildInputs = [ kauth kcodecs kconfig kwidgetsaddons ];
  outputs = [ "out" "dev" ];
  outputBin = "dev";
  postInstall = ''
    moveToOutput ''${qtPluginPrefix:?}/designer/kconfigwidgets5widgets.so "$out"
  '';
}
