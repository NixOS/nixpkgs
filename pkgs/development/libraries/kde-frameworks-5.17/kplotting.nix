{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "kplotting";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
