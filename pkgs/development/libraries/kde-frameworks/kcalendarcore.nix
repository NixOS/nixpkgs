{
  mkDerivation,
  extra-cmake-modules,
  libical,
  qtbase,
}:

mkDerivation {
  pname = "kcalendarcore";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ libical ];
  outputs = [
    "out"
    "dev"
  ];
}
