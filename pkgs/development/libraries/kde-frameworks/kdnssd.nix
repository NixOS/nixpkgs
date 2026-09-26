{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  avahi,
  qtbase,
  qttools,
}:

mkDerivation {
  pname = "kdnssd";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    avahi
    qttools
  ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
  ];
}
