{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "kitemmodels";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
}
