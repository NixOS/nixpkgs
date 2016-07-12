{ extra-cmake-modules
, kcoreaddons
, kdeApp
, ki18n
, kiconthemes
, kparts
, kwindowsystem
, kxmlgui
, lib
}:

kdeApp {
  name = "kontactinterface";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kcoreaddons
    ki18n
    kiconthemes
    kparts
    kwindowsystem
    kxmlgui
  ];
}
