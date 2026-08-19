{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  qtbase,
  qttools,
  gperf,
}:

mkDerivation {
  pname = "kcodecs";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    qttools
    gperf
  ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
  ];
}
