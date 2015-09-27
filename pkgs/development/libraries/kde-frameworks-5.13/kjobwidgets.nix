{ mkDerivation, lib
, extra-cmake-modules
, kcoreaddons
, kwidgetsaddons
, qtx11extras
}:

mkDerivation {
  name = "kjobwidgets";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kcoreaddons kwidgetsaddons qtx11extras ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
