{ akonadi
, boost
, cyrus_sasl
, extra-cmake-modules
, kcmutils
, kdeApp
, kdelibs4support
, kdepimlibs
, kdoctools
, kitemmodels
, kmime
, lib
}:

kdeApp {
  name = "kmailtransport";
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
    kcmutils
    kdelibs4support
    kdepimlibs
    kdoctools
    kitemmodels
    kmime
  ];
}
