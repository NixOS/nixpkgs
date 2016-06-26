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
    description = "The KDE calendar access library";
    license = with lib.licenses; [ lgpl21Plus ];
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
