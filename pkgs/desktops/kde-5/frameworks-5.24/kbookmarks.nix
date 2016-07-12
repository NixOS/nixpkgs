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
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kcodecs kconfig kconfigwidgets kcoreaddons kiconthemes kxmlgui
  ];
}
