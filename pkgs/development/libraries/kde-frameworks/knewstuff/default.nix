{
  mkDerivation, fetchpatch,
  extra-cmake-modules,
  attica, karchive, kcompletion, kconfig, kcoreaddons, ki18n, kiconthemes,
  kio, kitemviews, kpackage, kservice, ktextwidgets, kwidgetsaddons, kxmlgui, qtbase,
  qtdeclarative, kirigami2,
}:

mkDerivation {
  name = "knewstuff";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    karchive kcompletion kconfig kcoreaddons ki18n kiconthemes kio kitemviews
    kpackage
    ktextwidgets kwidgetsaddons qtbase qtdeclarative kirigami2
  ];
  propagatedBuildInputs = [ attica kservice kxmlgui ];
  patches = [
    ./0001-Delay-resolving-knsrcdir.patch
  ];
}
