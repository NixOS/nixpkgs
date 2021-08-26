{
  mkDerivation,
  extra-cmake-modules,
  karchive, kcoreaddons, kservice, qtbase,
}:

mkDerivation {
  name = "kemoticons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive kcoreaddons ];
  propagatedBuildInputs = [ kservice qtbase ];
}
