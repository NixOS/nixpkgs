{
  mkDerivation, lib,
  extra-cmake-modules, isocodes,
  kcoreaddons, kconfig, kcodecs, ki18n, qtbase,
}:

mkDerivation {
  pname = "kcontacts";
  meta = {
    license = [ lib.licenses.lgpl21 ];
  };
  propagatedBuildInputs = [
    isocodes
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons kconfig kcodecs ki18n qtbase ];
  outputs = [ "out" "dev" ];
}
