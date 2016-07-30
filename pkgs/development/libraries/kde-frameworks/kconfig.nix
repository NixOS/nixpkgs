{ kdeFramework, lib, ecm }:

kdeFramework {
  name = "kconfig";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
}
