{ kdeFramework, lib
, extra-cmake-modules
, kconfigwidgets
, ki18n
, kitemviews
, qtsvg
}:

kdeFramework {
  name = "kiconthemes";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kconfigwidgets ki18n kitemviews qtsvg ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
