{
  mkDerivation,
  extra-cmake-modules, perl,
  karchive, kconfig, kguiaddons, ki18n, kiconthemes, kio, kparts, libgit2,
  qtscript, qtxmlpatterns, sonnet, syntax-highlighting, qtquickcontrols,
  editorconfig-core-c
}:

mkDerivation {
  pname = "ktexteditor";
  nativeBuildInputs = [ extra-cmake-modules perl ];
  buildInputs = [
    karchive kconfig kguiaddons ki18n kiconthemes kio libgit2 qtscript
    qtxmlpatterns sonnet syntax-highlighting qtquickcontrols
    editorconfig-core-c
  ];
  propagatedBuildInputs = [ kparts ];
}
