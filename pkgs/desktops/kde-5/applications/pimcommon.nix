{ akonadi
, akonadi-mime
, akonadi-contacts
, boost
, cyrus_sasl
, ecm
, grantlee
, kcalcore
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdoctools
, kimap
, kitemmodels
, kjobwidgets
, kmime
, knewstuff
, kpimtextedit
, kservice
, kxmlgui
, lib
, libical
, libkdepim
, qtwebengine
, solid
}:

kdeApp {
  name = "pimcommon";
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
    boost
    cyrus_sasl
    grantlee
    kcalcore
    kcompletion
    kcontacts
    kdelibs4support
    kdoctools
    kimap
    kitemmodels
    kjobwidgets
    kmime
    knewstuff
    kpimtextedit
    kservice
    kxmlgui
    libical
    libkdepim
    qtwebengine
    solid
  ];
}
