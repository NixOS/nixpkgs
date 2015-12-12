{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "karchive";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
