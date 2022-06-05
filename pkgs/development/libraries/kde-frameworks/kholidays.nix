{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  qtbase, qtdeclarative, qttools,
}:

mkDerivation {
  pname = "kholidays";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 fdl12 ];
    maintainers = with lib.maintainers; [ bkchr ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ qtbase qtdeclarative qttools ];
  outputs = [ "out" "dev" ];
}
