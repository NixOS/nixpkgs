{ plasmaPackage, ecm, kcoreaddons, ki18n, kpty
, knotifications, kdbusaddons
}:

plasmaPackage {
  name = "kwrited";
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ kcoreaddons ki18n kpty knotifications kdbusaddons ];
}
