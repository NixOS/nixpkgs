{ akonadi
, boost
, cyrus_sasl
, ecm
, grantlee
, kcalcore
, kcontacts
, kdbusaddons
, kdeApp
, kdelibs4support
, kdoctools
, kio
, kitemmodels
, kldap
, kmbox
, kmime
, lib
, libical
, openldap
}:

kdeApp {
  name = "kdepimlibs";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    ecm
  ];
  buildInputs = [
    akonadi.unwrapped
    boost
    cyrus_sasl
    grantlee
    kcalcore
    kcontacts
    kdbusaddons
    kdelibs4support
    kdoctools
    kio
    kitemmodels
    kldap
    kmbox
    kmime
    libical
    openldap
  ];
}
