{ kdeFramework, lib, ecm, kcoreaddons, ki18n }:

kdeFramework {
  name = "kpty";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ kcoreaddons ki18n ];
}
