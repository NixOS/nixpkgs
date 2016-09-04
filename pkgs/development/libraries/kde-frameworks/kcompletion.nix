{ kdeFramework, lib, ecm, kconfig, kwidgetsaddons }:

kdeFramework {
  name = "kcompletion";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ kconfig kwidgetsaddons ];
}
