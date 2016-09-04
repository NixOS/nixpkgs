{ kdeFramework, lib, ecm, ki18n, kio }:

kdeFramework {
  name = "kxmlrpcclient";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ ki18n kio ];
}
