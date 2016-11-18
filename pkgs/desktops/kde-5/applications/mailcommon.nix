{ akonadi
, akonadi-contacts
, akonadi-mime
, boost
, cyrus_sasl
, ecm
, gpgmepp
, kcalcore
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdoctools
, kidentitymanagement
, kimap
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
, libkleo
, mailimporter
, messagelib
, openldap
, pimcommon
, qt5
, solid
}:

kdeApp {
  name = "mailcommon";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    ecm
  ];
  buildInputs = [
    akonadi
    akonadi-contacts
    akonadi-mime
    boost
    cyrus_sasl
    gpgmepp
    kcalcore
    kcompletion
    kcontacts
    kdelibs4support
    kdoctools
    kidentitymanagement
    kimap
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
    libkleo
    mailimporter
    messagelib
    openldap
    pimcommon
    qt5.qtwebengine
    solid
  ];
}
