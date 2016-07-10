{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "threadweaver";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
}
