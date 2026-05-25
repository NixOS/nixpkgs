{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  qtbase,
}:

mkDerivation {
  pname = "threadweaver";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
  ];
}
