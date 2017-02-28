{ kdeFramework, lib, extra-cmake-modules, qtbase }:

kdeFramework {
  name = "karchive";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
}
