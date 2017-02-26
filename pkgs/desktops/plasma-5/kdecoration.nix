{ plasmaPackage, extra-cmake-modules, qtbase }:

plasmaPackage {
  name = "kdecoration";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
}
