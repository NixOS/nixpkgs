{ mkDerivation, lib
, extra-cmake-modules
, aspell, qtbase, qttools
}:

mkDerivation {
  name = "sonnet";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ aspell qttools ];
  propagatedBuildInputs = [ qtbase ];
}
