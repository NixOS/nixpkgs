{
  mkDerivation,
  extra-cmake-modules,
  kdoctools,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kiconthemes,
  kio,
  kitemviews,
  kplotting,
  ktextwidgets,
  kwidgetsaddons,
  kxmlgui,
  qttools,
  sonnet,
}:

mkDerivation {
  pname = "kdesignerplugin";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kiconthemes
    kio
    kitemviews
    kplotting
    ktextwidgets
    kwidgetsaddons
    kxmlgui
    sonnet
  ];
  propagatedBuildInputs = [ qttools ];
}
