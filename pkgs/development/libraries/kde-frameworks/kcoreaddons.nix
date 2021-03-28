{
  mkDerivation, lib,
  extra-cmake-modules,
  qtbase, qttools, shared-mime-info
}:

mkDerivation {
  name = "kcoreaddons";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools shared-mime-info ];
  propagatedBuildInputs = [ qtbase ];
}
