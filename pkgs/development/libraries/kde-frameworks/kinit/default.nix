{
  kdeFramework, lib, copyPathsToStore,
  ecm, kdoctools,
  kconfig, kcrash, ki18n, kio, kservice, kwindowsystem
}:

kdeFramework {
  name = "kinit";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm kdoctools ];
  propagatedBuildInputs = [
    kconfig kcrash ki18n kio kservice kwindowsystem
  ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
