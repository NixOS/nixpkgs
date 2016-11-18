{ akonadi
, akonadi-calendar
, boost
, cyrus_sasl
, ecm
, kalarmcal
, kcalcore
, kcalutils
, kcontacts
, kdeApp
, kdelibs4support
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
, qtwebengine
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
    ecm
  ];
  buildInputs = [
    akonadi.unwrapped
    akonadi-calendar
    boost
    cyrus_sasl
    kalarmcal
    kcalcore
    kcalutils
    kcontacts
    kdelibs4support
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
    qtwebengine
    shared_mime_info
    syndication
  ];
}
