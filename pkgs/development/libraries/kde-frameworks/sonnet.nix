{ mkDerivation
, extra-cmake-modules
, aspell, qtbase, qttools
}:

mkDerivation {
  name = "sonnet";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ aspell qttools ];
  propagatedBuildInputs = [ qtbase ];
}
