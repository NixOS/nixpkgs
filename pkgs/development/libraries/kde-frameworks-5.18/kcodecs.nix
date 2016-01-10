{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "kcodecs";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
