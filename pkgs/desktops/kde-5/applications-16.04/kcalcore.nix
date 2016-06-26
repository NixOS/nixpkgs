{ extra-cmake-modules
, kdeApp
, kdelibs4support
, kdoctools
, lib
, libical
}:

kdeApp {
  name = "kcalcore";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kdelibs4support
    kdoctools
    libical
  ];
}
