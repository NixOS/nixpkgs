{
  mkDerivation, lib,
  extra-cmake-modules,
  kcompletion, kconfig, ki18n, kio, phonon, qtbase,
}:

mkDerivation {
  name = "knotifyconfig";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcompletion kconfig ki18n kio phonon ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [ "out" "dev" ];
}
