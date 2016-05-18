{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, kxmlgui
, ki18n
, kio
, kdelibs4support
, dolphin
}:

kdeApp {
  name = "dolphin-plugins";
  meta = {
    license = [ lib.licenses.gpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  propagatedBuildInputs = [
    kdelibs4support ki18n kio kxmlgui dolphin
  ];
}
