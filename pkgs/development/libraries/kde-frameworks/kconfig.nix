{ mkDerivation, extra-cmake-modules, qtbase, qttools }:

mkDerivation {
  name = "kconfig";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qttools ];
  propagatedBuildInputs = [ qtbase ];
}
