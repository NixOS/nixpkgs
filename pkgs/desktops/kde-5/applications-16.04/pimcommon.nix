{ akonadi
, boost
, cyrus_sasl
, extra-cmake-modules
, grantlee
, kcalcore
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdepimlibs
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
, qt5
, solid
}:

kdeApp {
  name = "pimcommon";
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
    grantlee
    kcalcore
    kcompletion
    kcontacts
    kdelibs4support
    kdepimlibs
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
    qt5.qtwebkit
    solid
  ];
}
