{ extra-cmake-modules
, grantlee
, kcalcore
, kconfig
, kcoreaddons
, kdeApp
, kdelibs4support
, kdoctools
, ki18n
, kidentitymanagement
, kpimtextedit
, lib
, libical
}:

kdeApp {
  name = "kcalutils";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    grantlee
    kcalcore
    kconfig
    kcoreaddons
    kdelibs4support
    kdoctools
    ki18n
    kidentitymanagement
    kpimtextedit
    libical
  ];
}
