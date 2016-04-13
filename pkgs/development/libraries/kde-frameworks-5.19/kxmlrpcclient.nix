{ kdeFramework, lib, extra-cmake-modules, ki18n, kio }:

kdeFramework {
  name = "kxmlrpcclient";
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ ki18n kio ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
