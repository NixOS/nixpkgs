{
  mkDerivation, lib,
  extra-cmake-modules,
  kcoreaddons, ki18n, kpty, kservice, qtbase,
}:

mkDerivation {
  name = "kdesu";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons ki18n kpty kservice qtbase ];
  propagatedBuildInputs = [ kpty ];
  outputs = [ "out" "dev" ];
}
