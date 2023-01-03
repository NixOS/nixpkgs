{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kcoreaddons, kio, qtxmlpatterns,
}:

mkDerivation {
  pname = "kdav";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kcoreaddons kio qtxmlpatterns ];
  outputs = [ "out" "dev" ];
}
