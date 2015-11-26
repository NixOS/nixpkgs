{ kdeFramework, lib, extra-cmake-modules, giflib, karchive
, kcodecs, kglobalaccel, ki18n, kiconthemes, kio, kjs
, knotifications, kparts, ktextwidgets, kwallet, kwidgetsaddons
, kwindowsystem, kxmlgui, perl, phonon, qtx11extras, sonnet
}:

kdeFramework {
  name = "khtml";
  nativeBuildInputs = [ extra-cmake-modules perl ];
  buildInputs = [
    giflib karchive kiconthemes knotifications kwallet kwidgetsaddons
    kwindowsystem kxmlgui phonon qtx11extras sonnet
  ];
  propagatedBuildInputs = [
    kcodecs kglobalaccel ki18n kio kjs kparts ktextwidgets
  ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
