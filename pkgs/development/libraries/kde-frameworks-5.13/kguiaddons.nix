{ mkDerivation, lib
, extra-cmake-modules
, qtx11extras
}:

mkDerivation {
  name = "kguiaddons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtx11extras ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
