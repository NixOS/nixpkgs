{
  mkDerivation, lib, extra-cmake-modules, qtbase
, qtdeclarative, kconfig, kcoreaddons, ki18n, kio, kirigami2
, fetchpatch
}:

mkDerivation {
  name = "purpose";
  meta = { maintainers = [ lib.maintainers.bkchr ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    qtbase qtdeclarative kconfig kcoreaddons
    ki18n kio kirigami2
  ];
}
