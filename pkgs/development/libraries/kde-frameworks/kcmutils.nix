{
  mkDerivation,
  extra-cmake-modules,
  kconfigwidgets,
  kcoreaddons,
  kdeclarative,
  ki18n,
  kiconthemes,
  kitemviews,
  kpackage,
  kservice,
  kxmlgui,
  qtdeclarative,
}:

mkDerivation {
  pname = "kcmutils";
  outputs = [
    "out"
    "dev"
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcoreaddons
    kdeclarative
    ki18n
    kiconthemes
    kitemviews
    kpackage
    kxmlgui
    qtdeclarative
  ];
  propagatedBuildInputs = [
    kconfigwidgets
    kservice
  ];
}
