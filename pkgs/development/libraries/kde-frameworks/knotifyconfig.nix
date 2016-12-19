{ kdeFramework, lib, ecm, kcompletion, kconfig
, ki18n, kio, phonon
}:

kdeFramework {
  name = "knotifyconfig";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ kcompletion kconfig ki18n kio phonon ];
}
