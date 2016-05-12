{ kdeApp
, lib
, extra-cmake-modules
, kconfig
, ki18n
, kxmlgui
, kparts
, kcoreaddons
, kcodecs
, kio
}:

kdeApp {
  name = "libkomparediff2";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kconfig ki18n kxmlgui kparts kcoreaddons kcodecs kio
  ];
  meta = {
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = [ lib.maintainers.ambrop72 ];
  };
}
