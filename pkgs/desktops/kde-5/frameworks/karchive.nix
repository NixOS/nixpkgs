{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "karchive";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
}
