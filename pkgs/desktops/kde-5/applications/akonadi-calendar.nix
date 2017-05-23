{ akonadi
, akonadi-contacts
, akonadi-mime
, boost
, cyrus_sasl
, ecm
, kcalcore
, kcalutils
, kcontacts
, kdeApp
, kdelibs4support
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
    ecm
  ];
  buildInputs = [
    akonadi.unwrapped
    akonadi-contacts
    akonadi-mime
    boost
    cyrus_sasl
    kcalcore
    kcalutils
    kcontacts
    kdelibs4support
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
