{
  mkDerivation, lib,
  extra-cmake-modules, perl,
  giflib, karchive, kcodecs, kglobalaccel, ki18n, kiconthemes, kio, kjs,
  knotifications, kparts, ktextwidgets, kwallet, kwidgetsaddons, kwindowsystem,
  kxmlgui, phonon, qtx11extras, sonnet, gperf
}:

mkDerivation {
  name = "khtml";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules perl ];
  buildInputs = [
    giflib karchive kcodecs kglobalaccel ki18n kiconthemes kio knotifications
    kparts ktextwidgets kwallet kwidgetsaddons kwindowsystem kxmlgui phonon
    qtx11extras sonnet gperf
  ];
  propagatedBuildInputs = [ kjs ];
}
