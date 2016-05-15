{ kdeFramework, lib, extra-cmake-modules, kcompletion, kconfig
, ki18n, kio, phonon
}:

kdeFramework {
  name = "knotifyconfig";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ kcompletion kconfig ki18n kio phonon ];
}
