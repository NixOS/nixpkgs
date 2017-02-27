{ kdeFramework, lib
, extra-cmake-modules, qttools
, avahi, qtbase
}:

kdeFramework {
  name = "kdnssd";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  propagatedBuildInputs = [ avahi ];
  buildInputs = [ qtbase ];
}
