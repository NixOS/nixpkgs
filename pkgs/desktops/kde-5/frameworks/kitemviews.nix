{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "kitemviews";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
}
