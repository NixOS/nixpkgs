{ kdeFramework, lib, copyPathsToStore
, ecm
, karchive, kconfigwidgets, ki18n, breeze-icons, kitemviews, qtsvg
}:

kdeFramework {
  name = "kiconthemes";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ breeze-icons kconfigwidgets karchive ki18n kitemviews qtsvg ];
}
