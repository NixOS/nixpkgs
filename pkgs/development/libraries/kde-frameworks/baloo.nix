{
  mkDerivation,
  extra-cmake-modules,
  kauth, kconfig, kcoreaddons, kcrash, kdbusaddons, kfilemetadata, ki18n,
  kidletime, kio, lmdb, qtbase, qtdeclarative, solid,
}:

mkDerivation {
  name = "baloo";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kauth kconfig kcrash kdbusaddons ki18n kio kidletime lmdb qtdeclarative
    solid
  ];
  outputs = [ "out" "dev" ];
  propagatedBuildInputs = [ kcoreaddons kfilemetadata qtbase ];
}
