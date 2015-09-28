{ mkDerivation, lib
, extra-cmake-modules
, giflib
, karchive
, kcodecs
, kglobalaccel
, ki18n
, kiconthemes
, kio
, kjs
, knotifications
, kparts
, ktextwidgets
, kwallet
, kwidgetsaddons
, kwindowsystem
, kxmlgui
, perl
, phonon
, qtx11extras
, sonnet
}:

mkDerivation {
  name = "khtml";
  nativeBuildInputs = [ extra-cmake-modules perl ];
  buildInputs = [
    giflib karchive kglobalaccel kiconthemes knotifications kwallet
    kwidgetsaddons kwindowsystem kxmlgui phonon qtx11extras sonnet
  ];
  propagatedBuildInputs = [ kcodecs ki18n kio kjs kparts ktextwidgets ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
