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
    kxmlgui phonon
  ];
  propagatedBuildInputs = [
    kcodecs kglobalaccel ki18n kio kjs kparts ktextwidgets
    kwindowsystem qtx11extras sonnet
  ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
