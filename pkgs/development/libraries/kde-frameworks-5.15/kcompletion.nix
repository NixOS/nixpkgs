{ kdeFramework, lib
, extra-cmake-modules
, kconfig
, kwidgetsaddons
}:

kdeFramework {
  name = "kcompletion";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kconfig kwidgetsaddons ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
