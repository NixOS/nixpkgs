{ kdeFramework, lib, extra-cmake-modules, kconfigwidgets
, kcoreaddons, kdeclarative, ki18n, kiconthemes, kitemviews
, kpackage, kservice, kxmlgui
}:

kdeFramework {
  name = "kcmutils";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcoreaddons ki18n kiconthemes kitemviews kpackage kxmlgui
  ];
  propagatedBuildInputs = [ kconfigwidgets kdeclarative kservice ];
  patches = [ ./kcmutils-pluginselector-follow-symlinks.patch ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
