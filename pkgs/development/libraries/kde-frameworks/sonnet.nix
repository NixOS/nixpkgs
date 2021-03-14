{ mkDerivation, lib
, extra-cmake-modules
, aspell, qtbase, qttools
}:

mkDerivation {
  name = "sonnet";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.7.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ aspell qttools ];
  propagatedBuildInputs = [ qtbase ];
}
