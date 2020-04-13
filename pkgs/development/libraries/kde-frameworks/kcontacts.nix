{
  mkDerivation, lib,
  extra-cmake-modules,
  kcoreaddons, kconfig, kcodecs, ki18n, qtbase,
}:

mkDerivation {
  name = "kcontacts";
  meta = {
    license = [ lib.licenses.lgpl21 ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons kconfig kcodecs ki18n qtbase ];
  outputs = [ "out" "dev" ];
}
