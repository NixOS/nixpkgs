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
  meta = with lib; {
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
      fdl12Plus
    ];
    maintainers = with maintainers; [ bkchr ];
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
