{
  mkDerivation, lib, fetchurl, writeScript,
  extra-cmake-modules,
  qtbase, qttools, shared-mime-info
}:

mkDerivation {
  name = "kcoreaddons";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.7.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools shared-mime-info ];
  propagatedBuildInputs = [ qtbase ];
}
