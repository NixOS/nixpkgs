{ kdeFramework, lib, ecm, python }:

kdeFramework {
  name = "kapidox";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm python ];
}
