{
  kdeFramework, lib, copyPathsToStore,
  extra-cmake-modules, kdoctools,
  kconfig, kcrash, ki18n, kio, kservice, kwindowsystem
}:

kdeFramework {
  name = "kinit";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kconfig kcrash ki18n kio kservice kwindowsystem
  ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
