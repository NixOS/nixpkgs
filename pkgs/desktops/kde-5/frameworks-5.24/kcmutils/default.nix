{ kdeFramework, lib, extra-cmake-modules, kconfigwidgets
, kcoreaddons, kdeclarative, ki18n, kiconthemes, kitemviews
, kpackage, kservice, kxmlgui
}:

kdeFramework {
  name = "kcmutils";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  propagatedBuildInputs = [
    kconfigwidgets kcoreaddons kdeclarative ki18n kiconthemes kitemviews
    kpackage kservice kxmlgui
  ];
  patches = [ ./0001-qdiriterator-follow-symlinks.patch ];
}
