{ kdeFramework, lib
, extra-cmake-modules
, kcoreaddons
, kwidgetsaddons
, qttools, qtx11extras
}:

kdeFramework {
  name = "kjobwidgets";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  propagatedBuildInputs = [ kcoreaddons kwidgetsaddons qtx11extras ];
}
