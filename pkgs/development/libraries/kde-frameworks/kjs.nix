{
  mkDerivation,
  extra-cmake-modules,
  kdoctools,
  pcre,
  qtbase,
}:

mkDerivation {
  pname = "kjs";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    pcre
    qtbase
  ];
}
