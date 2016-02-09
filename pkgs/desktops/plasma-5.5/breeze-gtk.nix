{ plasmaPackage
, extra-cmake-modules
}:

plasmaPackage {
  name = "breeze-gtk";
  nativeBuildInputs = [ extra-cmake-modules ];
}
