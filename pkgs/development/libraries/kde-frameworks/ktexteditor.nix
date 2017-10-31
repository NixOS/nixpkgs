{
  mkDerivation, lib, copyPathsToStore, fetchpatch,
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
  patches = [ (fetchpatch {
    url = "https://cgit.kde.org/ktexteditor.git/patch/?id=aeebeadb5f5955995c17de56cf83ba7166a132dd";
    sha256 = "10a61w1qyw3czffl06xgccgd3yycz7s0hpg2vj0a24v05jhqiigf";
    name = "ktextedtor_fix_indenters.patch";
  })];
}
