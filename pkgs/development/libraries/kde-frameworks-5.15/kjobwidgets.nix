{ kdeFramework, lib
, extra-cmake-modules
, kcoreaddons
, kwidgetsaddons
, qtx11extras
}:

kdeFramework {
  name = "kjobwidgets";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons kwidgetsaddons ];
  propagatedBuildInputs = [ qtx11extras ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
