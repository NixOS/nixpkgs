{ kdeFramework, lib
, extra-cmake-modules
, kdoctools
}:

kdeFramework {
  name = "kjs";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
}
