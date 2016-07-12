{ kdeFramework, lib
, extra-cmake-modules
, avahi
}:

kdeFramework {
  name = "kdnssd";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ avahi ];
}
