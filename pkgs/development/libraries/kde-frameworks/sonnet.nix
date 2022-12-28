{ mkDerivation
, extra-cmake-modules
, aspell, qtbase, qttools
}:

mkDerivation {
  pname = "sonnet";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ aspell qttools ];
  propagatedBuildInputs = [ qtbase ];
}
