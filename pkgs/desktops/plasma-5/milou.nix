{
  mkDerivation,
  extra-cmake-modules,
  kcoreaddons, kdeclarative, ki18n, krunner, kservice, kitemmodels,
  plasma-framework,
  qtscript, qtdeclarative
}:

mkDerivation {
  name = "milou";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcoreaddons kdeclarative ki18n krunner kservice kitemmodels plasma-framework
    qtdeclarative qtscript
  ];
}
