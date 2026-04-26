{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  aspell,
  hunspell,
  qtbase,
  qttools,
}:

mkDerivation {
  pname = "sonnet";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    aspell
    hunspell
    qttools
  ];
  propagatedBuildInputs = [ qtbase ];
}
