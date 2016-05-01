{ kdeFramework, lib, copyPathsToStore, extra-cmake-modules, kconfig, kcrash
, kdoctools, ki18n, kio, kservice, kwindowsystem, libcap
, libcap_progs
}:

kdeFramework {
  name = "kinit";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools libcap_progs ];
  propagatedBuildInputs = [
    kconfig kcrash ki18n kio kservice kwindowsystem libcap
  ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
