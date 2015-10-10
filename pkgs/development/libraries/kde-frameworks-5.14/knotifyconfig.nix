{ kdeFramework, lib, extra-cmake-modules, kcompletion, kconfig
, ki18n, kio, phonon
}:

kdeFramework {
  name = "knotifyconfig";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcompletion kconfig kio phonon ];
  propagatedBuildInputs = [ ki18n ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
