{ plasmaPackage
, extra-cmake-modules
, fontforge
}:

plasmaPackage {
  name = "oxygen-fonts";
  nativeBuildInputs = [
    extra-cmake-modules
    fontforge
  ];
}
