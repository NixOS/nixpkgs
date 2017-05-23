{ akonadi
, akonadi-mime
, akonadi-contacts
, akonadi-search
, boost
, cyrus_sasl
, ecm
, kcalcore
, kcmutils
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
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
    ecm
  ];
  buildInputs = [
    akonadi.unwrapped
    akonadi-mime
    akonadi-contacts
    akonadi-search
    boost
    cyrus_sasl
    kcalcore
    kcmutils
    kcompletion
    kcontacts
    kdelibs4support
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
