{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "kplotting";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
}
