{ kdeFramework, lib, ecm, shared_mime_info }:

kdeFramework {
  name = "kcoreaddons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ shared_mime_info ];
}
