{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  qtbase,
  qtdeclarative,
  qttools,
}:

mkDerivation {
  pname = "kholidays";
  meta = {
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      fdl12Plus
    ];
    maintainers = with lib.maintainers; [ bkchr ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    qtbase
    qtdeclarative
    qttools
  ];
  outputs = [
    "out"
    "dev"
  ];
}
