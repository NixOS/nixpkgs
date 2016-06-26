{ akonadi
, boost
, extra-cmake-modules
, kcalcore
, kcmutils
, kconfig
, kcontacts
, kcrash
, kdeApp
, kdelibs4support
, kdepimlibs
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
    extra-cmake-modules
  ];
  buildInputs = [
    akonadi
    boost
    kcalcore
    kcmutils
    kconfig
    kcontacts
    kcrash
    kdelibs4support
    kdepimlibs
    kdoctools
    ki18n
    kitemmodels
    kmime
    krunner
    libical
    xapian
  ];
}
