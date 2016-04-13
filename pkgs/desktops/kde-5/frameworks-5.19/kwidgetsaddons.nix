{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "kwidgetsaddons";
  nativeBuildInputs = [ extra-cmake-modules ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
