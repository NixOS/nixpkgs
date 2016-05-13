{ kdeFramework, lib
, extra-cmake-modules
, kconfig
, kwidgetsaddons
}:

kdeFramework {
  name = "kcompletion";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ kconfig kwidgetsaddons ];
}
