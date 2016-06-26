{ extra-cmake-modules
, kcodecs
, kconfig
, kcoreaddons
, kdeApp
, ki18n
, lib
}:

kdeApp {
  name = "kcontacts";
  meta = {
    description = "Address book API for KDE";
    license = with lib.licenses; [ lgpl2Plus ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kcodecs
    kconfig
    kcoreaddons
    ki18n
  ];
}
