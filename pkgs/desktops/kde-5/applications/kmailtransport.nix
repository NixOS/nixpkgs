{ akonadi
, akonadi-mime
, boost
, cyrus_sasl
, ecm
, kcmutils
, kdeApp
, kdelibs4support
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
    ecm
  ];
  buildInputs = [
    akonadi.unwrapped
    akonadi-mime
    boost
    cyrus_sasl
    kcmutils
    kdelibs4support
    kdoctools
    kitemmodels
    kmime
  ];
}
