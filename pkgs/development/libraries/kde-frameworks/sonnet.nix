{ mkDerivation, lib
, extra-cmake-modules
, hunspell, qtbase, qttools
}:

mkDerivation {
  name = "sonnet";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ hunspell qttools ];
  propagatedBuildInputs = [ qtbase ];
}
