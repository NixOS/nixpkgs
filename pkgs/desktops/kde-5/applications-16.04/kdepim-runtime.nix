{ akonadi
, akonadi-calendar
, boost
, cyrus_sasl
, extra-cmake-modules
, kalarmcal
, kcalcore
, kcalutils
, kcontacts
, kdeApp
, kdelibs4support
, kdepimlibs
, kdoctools
, kholidays
, kidentitymanagement
, kimap
, kmailtransport
, kmbox
, kmime
, knotifyconfig
, kpimtextedit
, kross
, lib
, libical
, qt5
, shared_mime_info
, syndication
}:

kdeApp {
  name = "kdepim-runtime";
  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    akonadi
    akonadi-calendar
    boost
    cyrus_sasl
    kalarmcal
    kcalcore
    kcalutils
    kcontacts
    kdelibs4support
    kdepimlibs
    kdoctools
    kholidays
    kidentitymanagement
    kimap
    kmailtransport
    kmbox
    kmime
    knotifyconfig
    kpimtextedit
    kross
    libical
    qt5.qtwebkit
    shared_mime_info
    syndication
  ];
}
