{ akonadi
, akonadi-contacts
, akonadi-mime
, boost
, cyrus_sasl
, ecm
, kcalcore
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdepim-apps-libs
, kdgantt2
, kdoctools
, kidentitymanagement
, kimap
, kitemmodels
, kjobwidgets
, kmailtransport
, kmime
, knewstuff
, kpimtextedit
, kservice
, kxmlgui
, lib
, libical
, libkdepim
, pimcommon
, qtwebengine
, solid
}:

kdeApp {
  name = "libksieve";
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
    kcompletion
    kcontacts
    kdelibs4support
    kdepim-apps-libs
    kdgantt2
    kdoctools
    kidentitymanagement
    kimap
    kitemmodels
    kjobwidgets
    kmailtransport
    kmime
    knewstuff
    kpimtextedit
    kservice
    kxmlgui
    libical
    libkdepim
    pimcommon
    qtwebengine
    solid
  ];
}
