{
  mkDerivation,
  lib,
  extra-cmake-modules,
  libical
}:

mkDerivation {
  name = "kcalendarcore";
  meta = {
    maintainers = [ lib.maintainers.nyanloutre ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ libical ];
  outputs = [ "out" "dev" ];
}
