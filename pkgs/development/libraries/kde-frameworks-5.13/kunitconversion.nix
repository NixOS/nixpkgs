{ mkDerivation, lib
, extra-cmake-modules
, ki18n
}:

mkDerivation {
  name = "kunitconversion";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ki18n ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
