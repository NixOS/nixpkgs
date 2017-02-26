{ kdeFramework, lib
, extra-cmake-modules, qtbase
}:

kdeFramework {
  name = "kitemmodels";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
}
