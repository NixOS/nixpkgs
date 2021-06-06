{
  mkDerivation,
  extra-cmake-modules,
  qtbase, qttools, shared-mime-info
}:

mkDerivation {
  name = "kcoreaddons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools shared-mime-info ];
  propagatedBuildInputs = [ qtbase ];
}
