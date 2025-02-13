{
  mkDerivation,
  extra-cmake-modules,
  perl,
  qtbase,
  qttools,
}:

mkDerivation {
  pname = "syntax-highlighting";
  nativeBuildInputs = [
    extra-cmake-modules
    perl
  ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
}
