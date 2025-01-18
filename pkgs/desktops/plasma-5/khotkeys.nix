{
  mkDerivation,
  extra-cmake-modules,
  kdoctools,
  kcmutils,
  kdbusaddons,
  kdelibs4support,
  kglobalaccel,
  ki18n,
  kio,
  kxmlgui,
  plasma-framework,
  plasma-workspace,
  qtx11extras,
}:

mkDerivation {
  pname = "khotkeys";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcmutils
    kdbusaddons
    kdelibs4support
    kglobalaccel
    ki18n
    kio
    kxmlgui
    plasma-framework
    plasma-workspace
    qtx11extras
  ];
  outputs = [
    "bin"
    "dev"
    "out"
  ];
}
