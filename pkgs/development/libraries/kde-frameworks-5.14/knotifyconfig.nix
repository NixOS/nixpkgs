{ kdeFramework, lib
, extra-cmake-modules
, kcompletion
, kconfig
, ki18n
, kio
, phonon
}:

kdeFramework {
  name = "knotifyconfig";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcompletion kconfig ki18n kio phonon ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
