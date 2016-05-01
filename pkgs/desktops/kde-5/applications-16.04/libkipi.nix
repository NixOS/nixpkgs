{ kdeApp
, lib
, extra-cmake-modules
, kconfig
, ki18n
, kservice
, kxmlgui
}:

kdeApp {
  name = "libkipi";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  propagatedBuildInputs = [
    kconfig ki18n kservice kxmlgui
  ];
}
