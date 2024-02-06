{
  mkDerivation,
  extra-cmake-modules, qttools,
  kcompletion, kconfig, kconfigwidgets, ki18n, kiconthemes, kservice,
  kwindowsystem, qtbase, sonnet,
}:

mkDerivation {
  pname = "ktextwidgets";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcompletion kconfig kconfigwidgets kiconthemes kservice kwindowsystem
  ];
  propagatedBuildInputs = [ ki18n qtbase qttools sonnet ];
}
