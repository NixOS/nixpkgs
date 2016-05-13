{ kdeFramework, lib
, extra-cmake-modules
, kcoreaddons
, kwidgetsaddons
, qtx11extras
}:

kdeFramework {
  name = "kjobwidgets";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [ kcoreaddons kwidgetsaddons qtx11extras ];
}
