{ mkDerivation, lib
, extra-cmake-modules, perl, qtbase, qttools
}:

mkDerivation {
  name = "syntax-highlighting";
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules perl ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
}
