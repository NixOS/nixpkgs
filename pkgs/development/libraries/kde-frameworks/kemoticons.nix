{
  mkDerivation,
  extra-cmake-modules,
  karchive, kcoreaddons, kservice, qtbase,
}:

mkDerivation {
  pname = "kemoticons";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive kcoreaddons ];
  propagatedBuildInputs = [ kservice qtbase ];
}
