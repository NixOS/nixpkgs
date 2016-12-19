{
  kdeFramework, lib, ecm,
  kcodecs, kconfig, kconfigwidgets, kcoreaddons, kiconthemes, kxmlgui
}:

kdeFramework {
  name = "kbookmarks";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    kcodecs kconfig kconfigwidgets kcoreaddons kiconthemes kxmlgui
  ];
}
