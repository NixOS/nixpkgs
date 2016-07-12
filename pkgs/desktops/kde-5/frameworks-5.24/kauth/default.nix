{ kdeFramework, lib, copyPathsToStore
, extra-cmake-modules
, kcoreaddons
, polkit-qt
}:

kdeFramework {
  name = "kauth";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ kcoreaddons polkit-qt ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
