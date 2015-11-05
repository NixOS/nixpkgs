{ kdeFramework, lib, extra-cmake-modules, kcompletion, kconfig
, ki18n, kio, phonon
}:

kdeFramework {
  name = "knotifyconfig";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcompletion kconfig phonon ];
  propagatedBuildInputs = [ ki18n kio ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
