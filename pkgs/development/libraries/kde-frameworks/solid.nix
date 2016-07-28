{ kdeFramework, lib
, extra-cmake-modules
, qtdeclarative
}:

kdeFramework {
  name = "solid";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtdeclarative ];
}
