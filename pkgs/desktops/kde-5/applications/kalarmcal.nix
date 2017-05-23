{ akonadi
, boost
, ecm
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
    description = "The KAlarm client library";
    license = with lib.licenses; [ lgpl21Plus ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    ecm
  ];
  buildInputs = [
    akonadi.unwrapped
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
