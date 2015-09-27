{ mkDerivation, lib
, extra-cmake-modules
, kconfigwidgets
, ki18n
, kitemviews
, qtsvg
}:

mkDerivation {
  name = "kiconthemes";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kconfigwidgets ki18n kitemviews qtsvg ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
