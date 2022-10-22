{ mkDerivation, extra-cmake-modules, ki18n, qtbase, }:

mkDerivation {
  pname = "kunitconversion";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ki18n qtbase ];
  outputs = [ "out" "dev" ];
}
