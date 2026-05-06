{
  mkDerivation,
  extra-cmake-modules,
  qtbase,
  qttools,
}:

mkDerivation {
  pname = "kconfig";
  outputs = [
    "out"
    "dev"
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
}
