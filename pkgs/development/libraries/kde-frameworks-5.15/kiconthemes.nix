{ kdeFramework, lib, extra-cmake-modules, kconfigwidgets, ki18n
, kitemviews, qtsvg
}:

kdeFramework {
  name = "kiconthemes";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ kconfigwidgets kitemviews qtsvg ];
  propagatedBuildInputs = [ ki18n ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
