{ mkDerivation, lib
, extra-cmake-modules
}:

mkDerivation {
  name = "kwidgetsaddons";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
