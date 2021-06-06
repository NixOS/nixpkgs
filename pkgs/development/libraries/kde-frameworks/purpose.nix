{
  mkDerivation, extra-cmake-modules, qtbase
, qtdeclarative, kconfig, kcoreaddons, ki18n, kio, kirigami2
, fetchpatch
}:

mkDerivation {
  name = "purpose";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtbase qtdeclarative kconfig kcoreaddons
    ki18n kio kirigami2
  ];
}
