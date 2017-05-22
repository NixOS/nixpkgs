{
  mkDerivation, lib,
  extra-cmake-modules,
  karchive, kcoreaddons, kservice, qtbase,
}:

mkDerivation {
  name = "kemoticons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive kcoreaddons ];
  propagatedBuildInputs = [ kservice qtbase ];
}
