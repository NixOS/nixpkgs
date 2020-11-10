{
  mkDerivation, lib, fetchpatch,
  extra-cmake-modules,
  attica, karchive, kcompletion, kconfig, kcoreaddons, ki18n, kiconthemes,
  kio, kitemviews, kpackage, kservice, ktextwidgets, kwidgetsaddons, kxmlgui, qtbase,
  qtdeclarative, kirigami2,
}:

mkDerivation {
  name = "knewstuff";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    karchive kcompletion kconfig kcoreaddons ki18n kiconthemes kio kitemviews
    kpackage
    ktextwidgets kwidgetsaddons qtbase qtdeclarative kirigami2
  ];
  propagatedBuildInputs = [ attica kservice kxmlgui ];

  patches = [ (fetchpatch {
    url = "https://github.com/KDE/knewstuff/commit/dbf788c10130eaa3f5ea37a7f22eb4569471aa04.patch";
    sha256 = "1225rgqg1j120nvhgsahvsq2xlkg91lr37zp14x19krixxgx521j";
    revert = true;
  }) ];
}
