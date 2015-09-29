{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "kitemviews";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
