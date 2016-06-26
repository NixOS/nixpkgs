{ extra-cmake-modules
, kcalcore
, kcalutils
, kcontacts
, kdeApp
, kdelibs4support
, kdoctools
, lib
, libical
}:

kdeApp {
  name = "ktnef";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kcalcore
    kcalutils
    kcontacts
    kdelibs4support
    kdoctools
    libical
  ];
}
