{
  mkDerivation,
  extra-cmake-modules, perl,
  giflib, karchive, kcodecs, kglobalaccel, ki18n, kiconthemes, kio, kjs,
  knotifications, kparts, ktextwidgets, kwallet, kwidgetsaddons, kwindowsystem,
  kxmlgui, phonon, qtx11extras, sonnet, gperf
}:

mkDerivation {
  pname = "khtml";
  nativeBuildInputs = [ extra-cmake-modules perl ];
  buildInputs = [
    giflib karchive kcodecs kglobalaccel ki18n kiconthemes kio knotifications
    kparts ktextwidgets kwallet kwidgetsaddons kwindowsystem kxmlgui phonon
    qtx11extras sonnet gperf
  ];
  propagatedBuildInputs = [ kjs ];
}
