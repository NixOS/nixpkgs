{ kdeFramework, lib, extra-cmake-modules, qtbase, qttools }:

kdeFramework {
  name = "kconfig";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  buildInputs = [ qtbase ];
}
