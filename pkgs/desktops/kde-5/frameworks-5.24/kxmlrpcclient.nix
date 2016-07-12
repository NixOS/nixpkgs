{ kdeFramework, lib, extra-cmake-modules, ki18n, kio }:

kdeFramework {
  name = "kxmlrpcclient";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ ki18n kio ];
}
