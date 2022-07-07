{
  mkDerivation,
  extra-cmake-modules,
  plasma-framework
}:

mkDerivation {
  pname = "plasma-nano";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    plasma-framework
  ];
}
