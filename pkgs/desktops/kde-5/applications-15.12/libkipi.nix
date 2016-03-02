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
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kconfig ki18n kservice kxmlgui
  ];
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
