{ plasmaPackage
, extra-cmake-modules
, kcoreaddons
, ki18n
, kpty
, knotifications
, kdbusaddons
}:

plasmaPackage {
  name = "kwrited";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kcoreaddons
    ki18n
    kpty
    knotifications
    kdbusaddons
  ];
}
