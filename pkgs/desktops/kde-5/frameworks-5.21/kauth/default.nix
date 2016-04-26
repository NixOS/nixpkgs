{ kdeFramework, lib, copyPathsToStore
, extra-cmake-modules
, kcoreaddons
, polkit-qt
}:

kdeFramework {
  name = "kauth";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ polkit-qt ];
  propagatedBuildInputs = [ kcoreaddons ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
