{ akonadi
, akonadi-search
, boost
, cyrus_sasl
, extra-cmake-modules
, kcalcore
, kcmutils
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdepimlibs
, kdoctools
, kitemmodels
, kjobwidgets
, kldap
, kmime
, kservice
, kxmlgui
, lib
, libical
, openldap
, solid
}:

kdeApp {
  name = "libkdepim";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    akonadi
    akonadi-search
    boost
    cyrus_sasl
    kcalcore
    kcmutils
    kcompletion
    kcontacts
    kdelibs4support
    kdepimlibs
    kdoctools
    kitemmodels
    kjobwidgets
    kldap
    kmime
    kservice
    kxmlgui
    libical
    openldap
    solid
  ];
}
