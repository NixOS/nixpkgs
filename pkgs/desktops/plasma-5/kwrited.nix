{
  mkDerivation, lib,
  extra-cmake-modules,
  kcoreaddons, kdbusaddons, ki18n, knotifications, kpty, qtbase,
}:

mkDerivation {
  pname = "kwrited";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons kdbusaddons ki18n knotifications kpty qtbase ];
}
