{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  qtbase,
}:

mkDerivation {
  pname = "attica";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
  ];
}
