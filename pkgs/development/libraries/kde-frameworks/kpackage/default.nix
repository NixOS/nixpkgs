{ kdeFramework, lib, copyPathsToStore
, ecm
, karchive
, kconfig
, kcoreaddons
, kdoctools
, ki18n
}:

kdeFramework {
  name = "kpackage";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [ karchive kconfig kcoreaddons ki18n ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
