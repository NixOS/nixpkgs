{ plasmaPackage
, ecm
}:

plasmaPackage {
  name = "breeze-gtk";
  nativeBuildInputs = [ ecm ];
}
