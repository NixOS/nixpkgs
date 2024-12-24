{
  mkDerivation,
  extra-cmake-modules,
  kcoreaddons,
  kdeclarative,
  ki18n,
  kitemmodels,
  krunner,
  kservice,
  plasma-framework,
  qtscript,
  qtdeclarative,
}:

mkDerivation {
  pname = "milou";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcoreaddons
    kdeclarative
    ki18n
    kitemmodels
    krunner
    kservice
    plasma-framework
    qtdeclarative
    qtscript
  ];
}
