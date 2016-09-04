{
  kdeFramework, lib, ecm,
  epoxy, kconfig, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio, kpackage,
  kwidgetsaddons, kwindowsystem, pkgconfig, qtdeclarative
}:

kdeFramework {
  name = "kdeclarative";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    epoxy kconfig kglobalaccel kguiaddons ki18n kiconthemes kio kpackage
    kwidgetsaddons kwindowsystem qtdeclarative
  ];
}
