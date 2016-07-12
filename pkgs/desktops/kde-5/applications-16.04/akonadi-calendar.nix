{ akonadi
, boost
, cyrus_sasl
, extra-cmake-modules
, kcalcore
, kcalutils
, kcontacts
, kdeApp
, kdelibs4support
, kdepimlibs
, kdoctools
, kidentitymanagement
, kio
, kitemmodels
, kmailtransport
, kmime
, kpimtextedit
, lib
, libical
, syndication
}:

kdeApp {
  name = "akonadi-calendar";
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
    cyrus_sasl
    kcalcore
    kcalutils
    kcontacts
    kdelibs4support
    kdepimlibs
    kdoctools
    kidentitymanagement
    kio
    kitemmodels
    kmailtransport
    kmime
    kpimtextedit
    libical
    syndication
  ];
}
