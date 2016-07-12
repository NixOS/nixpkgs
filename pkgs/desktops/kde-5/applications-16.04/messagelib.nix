{ akonadi
, akonadi-search
, boost
, cyrus_sasl
, eventviews
, extra-cmake-modules
, gpgmepp
, grantlee
, grantleetheme
, kcalcore
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdepim-apps-libs
, kdepimlibs
, kdewebkit
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
, solid
, qt5
}:

kdeApp {
  name = "messagelib";
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
    eventviews
    gpgmepp
    grantlee
    grantleetheme
    kcalcore
    kcompletion
    kcontacts
    kdelibs4support
    kdepim-apps-libs
    kdepimlibs
    kdewebkit
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
    solid
    qt5.qtwebkit
  ];
}
