{ mkDerivation, lib
, extra-cmake-modules
, kcompletion
, kconfig
, ki18n
, kio
, phonon
}:

mkDerivation {
  name = "knotifyconfig";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcompletion kconfig ki18n kio phonon ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
