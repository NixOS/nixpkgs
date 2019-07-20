{
  mkDerivation, lib,
  extra-cmake-modules, perl,
  karchive, kconfig, kguiaddons, ki18n, kiconthemes, kio, kparts, libgit2,
  qtscript, qtxmlpatterns, sonnet, syntax-highlighting, qtquickcontrols
}:

mkDerivation {
  name = "ktexteditor";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules perl ];
  buildInputs = [
    karchive kconfig kguiaddons ki18n kiconthemes kio libgit2 qtscript
    qtxmlpatterns sonnet syntax-highlighting qtquickcontrols
  ];
  propagatedBuildInputs = [ kparts ];
}
