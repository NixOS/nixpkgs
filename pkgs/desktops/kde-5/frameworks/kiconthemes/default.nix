{ kdeFramework, lib, copyPathsToStore
, extra-cmake-modules
, karchive, kconfigwidgets, ki18n, breeze-icons, kitemviews, qtsvg
}:

kdeFramework {
  name = "kiconthemes";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ breeze-icons kconfigwidgets karchive ki18n kitemviews qtsvg ];
}
