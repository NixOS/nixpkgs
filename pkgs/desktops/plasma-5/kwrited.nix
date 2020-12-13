{
  mkDerivation, lib,
  extra-cmake-modules,
  kcoreaddons, kdbusaddons, ki18n, knotifications, kpty, qtbase,
}:

mkDerivation {
  name = "kwrited";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons kdbusaddons ki18n knotifications kpty qtbase ];
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
}
