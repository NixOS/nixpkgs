{ kdeFramework, lib, copyPathsToStore
, extra-cmake-modules, makeQtWrapper, perl
, karchive, kconfig, kguiaddons, kiconthemes, kparts
, libgit2
, qtscript, qtxmlpatterns
, ki18n, kio, sonnet
}:

kdeFramework {
  name = "ktexteditor";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper perl ];
  propagatedBuildInputs = [
    karchive kconfig kguiaddons ki18n kiconthemes kio kparts libgit2 qtscript
    qtxmlpatterns sonnet
  ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
}
