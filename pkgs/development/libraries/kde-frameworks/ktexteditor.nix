{ kdeFramework, lib, copyPathsToStore
, extra-cmake-modules, perl
, karchive, kconfig, kguiaddons, kiconthemes, kparts
, libgit2
, qtscript, qtxmlpatterns
, ki18n, kio, sonnet, syntax-highlighting
}:

kdeFramework {
  name = "ktexteditor";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules perl ];
  propagatedBuildInputs = [
    karchive kconfig kguiaddons ki18n kiconthemes kio kparts libgit2 qtscript
    qtxmlpatterns sonnet syntax-highlighting
  ];
}
