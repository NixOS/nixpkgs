{
  mkDerivation,
  extra-cmake-modules,
  qtquickcontrols2,
}:

mkDerivation {
  pname = "kquickcharts";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ qtquickcontrols2 ];
  outputs = [
    "out"
    "dev"
  ];
}
