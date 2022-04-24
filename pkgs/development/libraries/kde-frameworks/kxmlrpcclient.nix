{ mkDerivation, extra-cmake-modules, ki18n, kio }:

mkDerivation {
  pname = "kxmlrpcclient";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ ki18n ];
  propagatedBuildInputs = [ kio ];
  outputs = [ "out" "dev" ];
}
