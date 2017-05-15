{ mkDerivation, extra-cmake-modules, kcoreaddons, ki18n, kpty
, knotifications, kdbusaddons
}:

mkDerivation {
  name = "kwrited";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ kcoreaddons ki18n kpty knotifications kdbusaddons ];
}
