{ mkDerivation, lib
, extra-cmake-modules
, attica
, kconfig
, kconfigwidgets
, kglobalaccel
, ki18n
, kiconthemes
, kitemviews
, ktextwidgets
, kwindowsystem
, sonnet
}:

mkDerivation {
  name = "kxmlgui";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    attica kconfig kconfigwidgets kglobalaccel ki18n kiconthemes
    kitemviews ktextwidgets kwindowsystem sonnet
  ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
