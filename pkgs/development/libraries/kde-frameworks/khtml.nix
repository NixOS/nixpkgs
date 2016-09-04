{ kdeFramework, lib, ecm, giflib, karchive
, kcodecs, kglobalaccel, ki18n, kiconthemes, kio, kjs
, knotifications, kparts, ktextwidgets, kwallet, kwidgetsaddons
, kwindowsystem, kxmlgui, perl, phonon, qtx11extras, sonnet
}:

kdeFramework {
  name = "khtml";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm perl ];
  propagatedBuildInputs = [
    giflib karchive kcodecs kglobalaccel ki18n kiconthemes kio kjs
    knotifications kparts ktextwidgets kwallet kwidgetsaddons kwindowsystem
    kxmlgui phonon qtx11extras sonnet
  ];
}
