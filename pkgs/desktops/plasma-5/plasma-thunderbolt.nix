{ mkDerivation
, extra-cmake-modules
, kcmutils
, kcoreaddons
, bolt
}:

mkDerivation {
  name = "plasma-thunderbolt";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcmutils
    kcoreaddons
    bolt
  ];
}
