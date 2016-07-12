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
    description = "The KDE calendar utility library ";
    license = with lib.licenses; [ lgpl2Plus ];
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
