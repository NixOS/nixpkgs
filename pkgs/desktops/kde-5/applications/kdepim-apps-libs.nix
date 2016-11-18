{ akonadi
, akonadi-contacts
, boost
, cyrus_sasl
, ecm
, gpgmepp
, grantlee
, grantleetheme
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
, kpimtextedit
, kservice
, kxmlgui
, lib
, libical
, libkleo
, pimcommon
, qt5
, solid
}:

kdeApp {
  name = "kdepim-apps-libs";
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
    boost
    cyrus_sasl
    gpgmepp
    grantlee
    grantleetheme
    kcalcore
    kcompletion
    kcontacts
    kdelibs4support
    kdoctools
    kimap
    kitemmodels
    kjobwidgets
    kmime
    kpimtextedit
    kservice
    kxmlgui
    libical
    libkleo
    pimcommon
    qt5.qtwebengine
    solid
  ];
}
