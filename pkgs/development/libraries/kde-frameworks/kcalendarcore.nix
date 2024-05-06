{
  mkDerivation,
  extra-cmake-modules,
  libical,
}:

mkDerivation {
  pname = "kcalendarcore";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ libical ];
  outputs = [ "out" "dev" ];
}
