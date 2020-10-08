{
  mkDerivation, lib,
  extra-cmake-modules,
  breeze-icons, karchive, kcoreaddons, kconfigwidgets, ki18n, kitemviews,
  qtbase, qtsvg, qttools,
}:

mkDerivation {
  name = "kiconthemes";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  patches = [
    ./default-theme-breeze.patch
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    breeze-icons karchive kcoreaddons kconfigwidgets ki18n kitemviews
  ];
  propagatedBuildInputs = [ qtbase qtsvg qttools ];
}
