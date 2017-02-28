{ kdeFramework, lib, extra-cmake-modules, qtbase, qttools }:

kdeFramework {
  name = "kcodecs";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [ qtbase ];
}
