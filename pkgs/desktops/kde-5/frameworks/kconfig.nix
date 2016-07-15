{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "kconfig";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
}
