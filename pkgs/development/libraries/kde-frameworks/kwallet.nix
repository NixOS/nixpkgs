{ kdeFramework, lib, ecm, kconfig, kconfigwidgets
, kcoreaddons , kdbusaddons, kdoctools, ki18n, kiconthemes
, knotifications , kservice, kwidgetsaddons, kwindowsystem, libgcrypt
}:

kdeFramework {
  name = "kwallet";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [
    kconfig kconfigwidgets kcoreaddons kdbusaddons ki18n kiconthemes
    knotifications kservice kwidgetsaddons kwindowsystem libgcrypt
  ];
}
