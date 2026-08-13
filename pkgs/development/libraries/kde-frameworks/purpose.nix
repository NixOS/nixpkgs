{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  intltool,
  qtbase,
  accounts-qt,
  qtdeclarative,
  kconfig,
  kcoreaddons,
  ki18n,
  kio,
  kirigami2,
  signond,
}:

mkDerivation {
  pname = "purpose";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    intltool
  ];
  buildInputs = [
    qtbase
    accounts-qt
    qtdeclarative
    kconfig
    kcoreaddons
    ki18n
    kio
    kirigami2
    signond
  ];
}
