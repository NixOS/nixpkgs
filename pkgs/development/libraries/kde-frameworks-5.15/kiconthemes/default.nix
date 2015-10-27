{ kdeFramework, lib, extra-cmake-modules, kconfigwidgets, ki18n
, kitemviews, qtsvg
}:

kdeFramework {
  name = "kiconthemes";
  patches = [ ./0001-default-icon-theme.patch ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kconfigwidgets kitemviews qtsvg ];
  propagatedBuildInputs = [ ki18n ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
