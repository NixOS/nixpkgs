{
  mkDerivation,
  extra-cmake-modules,
  qtquickcontrols2,
  qtbase,
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
