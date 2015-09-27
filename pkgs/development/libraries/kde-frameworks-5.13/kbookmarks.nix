{ mkDerivation, lib
, extra-cmake-modules
, kcodecs
, kconfig
, kconfigwidgets
, kcoreaddons
, kiconthemes
, kxmlgui
}:

mkDerivation {
  name = "kbookmarks";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcodecs
    kconfig
    kconfigwidgets
    kcoreaddons
    kiconthemes
    kxmlgui
  ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
