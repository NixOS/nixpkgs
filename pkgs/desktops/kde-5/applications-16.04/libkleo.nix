{ extra-cmake-modules
, gpgmepp
, kcompletion
, kconfig
, kcoreaddons
, kdeApp
, ki18n
, kpimtextedit
, ktextwidgets
, kwidgetsaddons
, kwindowsystem
, lib
}:

kdeApp {
  name = "libkleo";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    gpgmepp
    kcompletion
    kconfig
    kcoreaddons
    ki18n
    kpimtextedit
    ktextwidgets
    kwidgetsaddons
    kwindowsystem
  ];
}
