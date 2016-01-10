{ kdeFramework, lib
, extra-cmake-modules
, kcodecs
, kconfig
, kconfigwidgets
, kcoreaddons
, kiconthemes
, kxmlgui
}:

kdeFramework {
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
