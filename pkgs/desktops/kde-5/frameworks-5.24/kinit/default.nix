{ kdeFramework, lib, copyPathsToStore, extra-cmake-modules, kconfig, kcrash
, kdoctools, ki18n, kio, kservice, kwindowsystem, libcap
}:

kdeFramework {
  name = "kinit";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools libcap.out ];
  propagatedBuildInputs = [
    kconfig kcrash ki18n kio kservice kwindowsystem libcap
  ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
