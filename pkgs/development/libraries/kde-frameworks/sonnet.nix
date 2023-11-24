{ mkDerivation
, extra-cmake-modules
, aspell, hunspell, qtbase, qttools
}:

mkDerivation {
  pname = "sonnet";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ aspell hunspell qttools ];
  propagatedBuildInputs = [ qtbase ];
}
