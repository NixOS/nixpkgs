{ kdeFramework, lib
, extra-cmake-modules
}:

kdeFramework {
  name = "kwidgetsaddons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
}
