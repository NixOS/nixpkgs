{
  mkDerivation,
  extra-cmake-modules,
  breeze-icons, karchive, kcoreaddons, kconfigwidgets, ki18n, kitemviews,
  qtbase, qtsvg, qttools,
}:

mkDerivation {
  pname = "kiconthemes";
  patches = [
    ./default-theme-breeze.patch
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    breeze-icons karchive kcoreaddons kconfigwidgets ki18n kitemviews
  ];
  propagatedBuildInputs = [ qtbase qtsvg qttools ];
}
