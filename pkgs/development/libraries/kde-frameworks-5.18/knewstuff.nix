{ kdeFramework, lib, extra-cmake-modules, attica, karchive
, kcompletion, kconfig, kcoreaddons, ki18n, kiconthemes, kio
, kitemviews, kservice, ktextwidgets, kwidgetsaddons, kxmlgui
}:

kdeFramework {
  name = "knewstuff";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    karchive kcompletion kconfig kcoreaddons kiconthemes
    kitemviews ktextwidgets kwidgetsaddons
  ];
  propagatedBuildInputs = [ attica ki18n kio kservice kxmlgui ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
