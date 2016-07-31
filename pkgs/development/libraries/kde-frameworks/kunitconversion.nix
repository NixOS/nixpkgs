{ kdeFramework, lib, ecm, ki18n }:

kdeFramework {
  name = "kunitconversion";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ ki18n ];
}
