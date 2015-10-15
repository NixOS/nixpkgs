{ kdeFramework, lib
, extra-cmake-modules
, avahi
}:

kdeFramework {
  name = "kdnssd";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ avahi ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
