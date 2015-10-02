{ plasmaPackage, extra-cmake-modules }:

plasmaPackage {
  name = "kdecoration";
  nativeBuildInputs = [ extra-cmake-modules ];
}
