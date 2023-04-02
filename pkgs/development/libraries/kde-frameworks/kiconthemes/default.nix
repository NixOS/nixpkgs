{
  mkDerivation, fetchpatch,
  extra-cmake-modules,
  breeze-icons, karchive, kcoreaddons, kconfigwidgets, ki18n, kitemviews,
  qtbase, qtsvg, qttools,
}:

mkDerivation {
  pname = "kiconthemes";
  patches = [
    ./default-theme-breeze.patch

    # fix compile error
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/kiconthemes/-/commit/d5d04e3c3fa92fbfd95eced39c3e272b8980563d.patch";
      hash = "sha256-8YGWJg7+LrPpezW8ubObcFovI5DCVn3gbdH7KDdEeQw=";
    })
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    breeze-icons karchive kcoreaddons kconfigwidgets ki18n kitemviews
  ];
  propagatedBuildInputs = [ qtbase qtsvg qttools ];
}
