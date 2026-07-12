{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  qtbase,
  qttools,
}:

mkDerivation {
  pname = "kitemviews";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
  ];
}
