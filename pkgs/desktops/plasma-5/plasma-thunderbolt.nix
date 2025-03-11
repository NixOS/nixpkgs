{
  mkDerivation,
  extra-cmake-modules,
  kcmutils,
  kcoreaddons,
  bolt,
}:

mkDerivation {
  pname = "plasma-thunderbolt";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcmutils
    kcoreaddons
    bolt
  ];
}
