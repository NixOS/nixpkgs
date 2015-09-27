{ mkDerivation
, extra-cmake-modules
, fontforge
}:

mkDerivation {
  name = "oxygen-fonts";
  nativeBuildInputs = [
    extra-cmake-modules
    fontforge
  ];
}
