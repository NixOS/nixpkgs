{
  mkDerivation, lib, copyPathsToStore,
  extra-cmake-modules,
  kconfigwidgets, kcoreaddons, kdeclarative, ki18n, kiconthemes, kitemviews,
  kpackage, kservice, kxmlgui, qtdeclarative,
}:

mkDerivation {
  name = "kcmutils";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcoreaddons kdeclarative ki18n kiconthemes kitemviews kpackage kxmlgui
    qtdeclarative
  ];
  propagatedBuildInputs = [ kconfigwidgets kservice ];
  patches = (copyPathsToStore (lib.readPathsFromFile ./. ./series));
}
