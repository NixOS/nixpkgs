{
  mkDerivation, lib, copyPathsToStore,
  extra-cmake-modules,
  breeze-icons, karchive, kcoreaddons, kconfigwidgets, ki18n, kitemviews,
  qtbase, qtsvg,
}:

mkDerivation {
  name = "kiconthemes";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  patches = [./default-theme-breeze.patch];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    breeze-icons karchive kcoreaddons kconfigwidgets ki18n kitemviews
  ];
  propagatedBuildInputs = [ qtbase qtsvg ];
}
