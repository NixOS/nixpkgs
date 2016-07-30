{ kdeFramework, lib, ecm }:

kdeFramework {
  name = "kcodecs";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
}
