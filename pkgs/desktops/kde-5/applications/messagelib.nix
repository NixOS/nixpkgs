{ akonadi
, akonadi-contacts
, akonadi-mime
, akonadi-notes
, akonadi-search
, boost
, cyrus_sasl
, eventviews
, ecm
, gpgmepp
, grantlee
, grantleetheme
, kcalcore
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdepim-apps-libs
, kdoctools
, kidentitymanagement
, kimap
, kitemmodels
, kjobwidgets
, kldap
, kmailtransport
, kmbox
, kmime
, kpimtextedit
, kservice
, kxmlgui
, lib
, libgravatar
, libical
, libkdepim
, libkleo
, openldap
, pimcommon
, qtwebengine
, qtwebkit
, solid
}:

kdeApp {
  name = "messagelib";
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
    akonadi-notes
    akonadi-search
    boost
    cyrus_sasl
    eventviews
    gpgmepp
    grantlee
    grantleetheme
    kcalcore
    kcompletion
    kcontacts
    kdelibs4support
    kdepim-apps-libs
    kdoctools
    kidentitymanagement
    kimap
    kitemmodels
    kjobwidgets
    kldap
    kmailtransport
    kmbox
    kmime
    kpimtextedit
    kservice
    kxmlgui
    libgravatar
    libical
    libkdepim
    libkleo
    openldap
    pimcommon
    qtwebengine
    qtwebkit
    solid
  ];
}
