{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kcoreaddons, kio, qtxmlpatterns,
}:

mkDerivation {
  name = "kdav";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcoreaddons kio qtxmlpatterns ];
  outputs = [ "out" "dev" ];
}
