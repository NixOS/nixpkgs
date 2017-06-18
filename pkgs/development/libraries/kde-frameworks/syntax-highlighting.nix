{ mkDerivation, lib
, extra-cmake-modules, perl, qtbase, qttools
}:

mkDerivation {
  name = "syntax-highlighting";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
    broken = builtins.compareVersions qtbase.version "5.6.0" < 0;
  };
  nativeBuildInputs = [ extra-cmake-modules perl ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
}
