{ kdeFramework, lib
, ecm
, karchive
, kconfig
, kcoreaddons
, kservice
}:

kdeFramework {
  name = "kemoticons";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ karchive kconfig kcoreaddons kservice ];
}
