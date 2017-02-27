{ kdeFramework, lib
, extra-cmake-modules, qtbase
}:

kdeFramework {
  name = "threadweaver";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
}
