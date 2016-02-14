{ kdeFramework, lib, extra-cmake-modules, kconfigwidgets
, kcoreaddons, kdeclarative, ki18n, kiconthemes, kitemviews
, kpackage, kservice, kxmlgui
}:

kdeFramework {
  name = "kcmutils";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kcoreaddons kiconthemes kitemviews kpackage kxmlgui
  ];
  propagatedBuildInputs = [ kconfigwidgets kdeclarative ki18n kservice ];
  patches = [ ./0001-qdiriterator-follow-symlinks.patch ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
