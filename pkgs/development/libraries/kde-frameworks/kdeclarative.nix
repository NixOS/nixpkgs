{
  kdeFramework, lib, extra-cmake-modules,
  epoxy, kconfig, kglobalaccel, kguiaddons, ki18n, kiconthemes, kio, kpackage,
  kwidgetsaddons, kwindowsystem, pkgconfig, qtdeclarative
}:

kdeFramework {
  name = "kdeclarative";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    epoxy kconfig kglobalaccel kguiaddons ki18n kiconthemes kio kpackage
    kwidgetsaddons kwindowsystem qtdeclarative
  ];
}
