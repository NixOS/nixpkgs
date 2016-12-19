{ kdeFramework, lib, ecm }:

kdeFramework {
  name = "karchive";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
}
