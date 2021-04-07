{
  mkDerivation, lib,
  extra-cmake-modules,
  kcoreaddons, kdeclarative, ki18n, kitemmodels, krunner, kservice,
  plasma-framework, qtbase, qtscript, qtdeclarative
}:

mkDerivation {
  name = "milou";
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcoreaddons kdeclarative ki18n kitemmodels krunner kservice plasma-framework
    qtdeclarative qtscript
  ];
}
