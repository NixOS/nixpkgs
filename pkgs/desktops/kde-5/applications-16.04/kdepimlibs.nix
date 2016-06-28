{ akonadi
, boost
, cyrus_sasl
, extra-cmake-modules
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
, qt5
}:

kdeApp {
  name = "kdepimlibs";
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
    qt5.qtwebkit
  ];
}
