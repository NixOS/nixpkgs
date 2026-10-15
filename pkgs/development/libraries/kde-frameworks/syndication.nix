{
  mkDerivation,
  lib,
  cmake,
  extra-cmake-modules,
  kcodecs,
}:

mkDerivation {
  pname = "syndication";
  meta.maintainers = [ lib.maintainers.bkchr ];
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [ kcodecs ];
  outputs = [
    "out"
    "dev"
  ];
}
