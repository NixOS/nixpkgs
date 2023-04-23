{
  mkDerivation,
  extra-cmake-modules,
  kconfig, kcoreaddons, ki18n, kiconthemes, kio, kjobwidgets, knotifications,
  kservice, ktextwidgets, kwidgetsaddons, kxmlgui
}:

mkDerivation {
  pname = "kparts";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kconfig kcoreaddons ki18n kiconthemes kjobwidgets knotifications kservice
    kwidgetsaddons
  ];
  propagatedBuildInputs = [ kio ktextwidgets kxmlgui ];
}
