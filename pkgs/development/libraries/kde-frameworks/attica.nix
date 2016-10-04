{ kdeFramework, lib, ecm }:

kdeFramework {
  name = "attica";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
}
