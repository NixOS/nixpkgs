{
  mkDerivation,
  extra-cmake-modules,
  libical,
  qtbase
}:

mkDerivation {
  name = "kcalendarcore";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ libical ];
  outputs = [ "out" "dev" ];
}
