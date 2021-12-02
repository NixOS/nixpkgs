{ mkDerivation, extra-cmake-modules, ki18n, qtbase, }:

mkDerivation {
  name = "kunitconversion";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ki18n qtbase ];
  outputs = [ "out" "dev" ];
}
