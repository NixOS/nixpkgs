{ akonadi
, akonadi-calendar
, akonadi-contacts
, akonadi-mime
, boost
, calendarsupport
, cyrus_sasl
, eventviews
, ecm
, kcalcore
, kcalutils
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdepim-apps-libs
, kdgantt2
, kdoctools
, kidentitymanagement
, kitemmodels
, kjobwidgets
, kldap
, kmailtransport
, kmime
, kpimtextedit
, kservice
, kxmlgui
, lib
, libical
, libkdepim
, openldap
, solid
}:

kdeApp {
  name = "incidenceeditor";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    ecm
  ];
  buildInputs = [
    akonadi.unwrapped
    akonadi-calendar
    akonadi-contacts
    akonadi-mime
    boost
    calendarsupport
    cyrus_sasl
    eventviews
    kcalcore
    kcalutils
    kcompletion
    kcontacts
    kdelibs4support
    kdepim-apps-libs
    kdgantt2
    kdoctools
    kidentitymanagement
    kitemmodels
    kjobwidgets
    kldap
    kmailtransport
    kmime
    kpimtextedit
    kservice
    kxmlgui
    libical
    libkdepim
    openldap
    solid
  ];
}
