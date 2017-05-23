{ akonadi
, akonadi-mime
, boost
, ecm
, kcalcore
, kcmutils
, kconfig
, kcontacts
, kcrash
, kdeApp
, kdelibs4support
, kdoctools
, ki18n
, kitemmodels
, kmime
, krunner
, lib
, libical
, xapian
}:

kdeApp {
  name = "akonadi-search";
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
    kcalcore
    kcmutils
    kconfig
    kcontacts
    kcrash
    kdelibs4support
    kdoctools
    ki18n
    kitemmodels
    kmime
    krunner
    libical
    xapian
  ];
}
