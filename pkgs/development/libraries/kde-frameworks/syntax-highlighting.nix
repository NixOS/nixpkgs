{ mkDerivation
, extra-cmake-modules, perl, qtbase, qttools
}:

mkDerivation {
  name = "syntax-highlighting";
  nativeBuildInputs = [ extra-cmake-modules perl ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
}
