{ mkDerivation, lib
, extra-cmake-modules
, kconfig
, kwidgetsaddons
}:

mkDerivation {
  name = "kcompletion";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kconfig kwidgetsaddons ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
