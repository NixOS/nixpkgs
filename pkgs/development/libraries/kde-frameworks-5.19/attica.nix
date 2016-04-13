{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "attica";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
