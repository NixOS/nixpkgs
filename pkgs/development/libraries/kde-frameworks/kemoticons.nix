{
  mkDerivation, lib,
  extra-cmake-modules,
  karchive, kconfig, kcoreaddons, kservice
}:

mkDerivation {
  name = "kemoticons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ karchive kconfig kcoreaddons kservice ];
}
