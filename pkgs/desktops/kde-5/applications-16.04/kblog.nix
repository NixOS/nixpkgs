{ extra-cmake-modules
, kcalcore
, kcoreaddons
, kdeApp
, kdelibs4support
, kdoctools
, kio
, kxmlrpcclient
, lib
, libical
, syndication
}:

kdeApp {
  name = "kblog";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kcalcore
    kcoreaddons
    kdelibs4support
    kdoctools
    kio
    kxmlrpcclient
    libical
    syndication
  ];
  propagatedBuildInputs = [
  ];
}
