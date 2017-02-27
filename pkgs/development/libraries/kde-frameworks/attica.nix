{ kdeFramework, lib, extra-cmake-modules, qtbase }:

kdeFramework {
  name = "attica";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
}
