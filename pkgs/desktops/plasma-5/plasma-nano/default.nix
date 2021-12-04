{
  mkDerivation,
  extra-cmake-modules,
  plasma-framework
}:

mkDerivation {
  name = "plasma-nano";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    plasma-framework
  ];
}
