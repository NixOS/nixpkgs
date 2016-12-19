{ kdeFramework, lib
, ecm
, kcoreaddons
, kwidgetsaddons
, qtx11extras
}:

kdeFramework {
  name = "kjobwidgets";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [ kcoreaddons kwidgetsaddons qtx11extras ];
}
