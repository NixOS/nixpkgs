{ kdeFramework, lib, copyPathsToStore
, extra-cmake-modules, makeQtWrapper, perl
, karchive, kconfig, kguiaddons, kiconthemes, kparts
, libgit2
, qtscript, qtxmlpatterns
, ki18n, kio, sonnet
}:

kdeFramework {
  name = "ktexteditor";
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper perl ];
  buildInputs = [
    karchive kconfig kguiaddons kiconthemes kparts
    libgit2
    qtscript qtxmlpatterns
  ];
  propagatedBuildInputs = [ ki18n kio sonnet ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
