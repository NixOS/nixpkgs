{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "kitemmodels";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
