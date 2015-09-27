{ mkDerivation, lib
, extra-cmake-modules
, ki18n
, kio
}:

mkDerivation {
  name = "kxmlrpcclient";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ki18n ];
  propagatedBuildInputs = [ kio ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
