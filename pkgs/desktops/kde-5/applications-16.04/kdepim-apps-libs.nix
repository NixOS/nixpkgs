{ akonadi
, boost
, cyrus_sasl
, extra-cmake-modules
, gpgmepp
, grantlee
, grantleetheme
, kcalcore
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdepimlibs
, kdewebkit
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
    extra-cmake-modules
  ];
  buildInputs = [
    akonadi
    boost
    cyrus_sasl
    gpgmepp
    grantlee
    grantleetheme
    kcalcore
    kcompletion
    kcontacts
    kdelibs4support
    kdepimlibs
    kdewebkit
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
    qt5.qtwebkit
    solid
  ];
}
