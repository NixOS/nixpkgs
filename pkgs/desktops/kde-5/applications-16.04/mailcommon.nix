{ akonadi
, boost
, cyrus_sasl
, extra-cmake-modules
, gpgmepp
, kcalcore
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdepimlibs
, kdewebkit
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
    extra-cmake-modules
  ];
  buildInputs = [
    akonadi
    boost
    cyrus_sasl
    gpgmepp
    kcalcore
    kcompletion
    kcontacts
    kdelibs4support
    kdepimlibs
    kdewebkit
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
    qt5.qtwebkit
    solid
  ];
}
