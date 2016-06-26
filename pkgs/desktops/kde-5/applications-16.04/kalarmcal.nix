{ akonadi
, boost
, extra-cmake-modules
, kcalcore
, kdeApp
, kdelibs4support
, kdoctools
, kholidays
, kidentitymanagement
, kpimtextedit
, lib
, libical
}:

kdeApp {
  name = "kalarmcal";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    akonadi
    boost
    kcalcore
    kdelibs4support
    kdoctools
    kholidays
    kidentitymanagement
    kpimtextedit
    libical
  ];
}
