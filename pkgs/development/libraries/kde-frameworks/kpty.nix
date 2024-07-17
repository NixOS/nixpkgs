{
  mkDerivation,
  extra-cmake-modules,
  kcoreaddons,
  ki18n,
  qtbase,
}:

mkDerivation {
  pname = "kpty";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcoreaddons
    ki18n
    qtbase
  ];
  outputs = [
    "out"
    "dev"
  ];
}
