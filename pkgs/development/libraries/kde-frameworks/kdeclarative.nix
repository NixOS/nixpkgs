{
  mkDerivation,
  extra-cmake-modules,
  libepoxy,
  kconfig,
  kglobalaccel,
  kguiaddons,
  ki18n,
  kiconthemes,
  kio,
  kpackage,
  kwidgetsaddons,
  kwindowsystem,
  qtdeclarative,
}:

mkDerivation {
  pname = "kdeclarative";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    libepoxy
    kglobalaccel
    kguiaddons
    ki18n
    kiconthemes
    kio
    kwidgetsaddons
    kwindowsystem
  ];
  propagatedBuildInputs = [
    kconfig
    kpackage
    qtdeclarative
  ];
}
