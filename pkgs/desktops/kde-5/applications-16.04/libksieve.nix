{ akonadi
, boost
, cyrus_sasl
, extra-cmake-modules
, kcalcore
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdepim-apps-libs
, kdepimlibs
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
, qt5
, solid
}:

kdeApp {
  name = "libksieve";
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
    kcalcore
    kcompletion
    kcontacts
    kdelibs4support
    kdepim-apps-libs
    kdepimlibs
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
    qt5.qtwebkit
    solid
  ];
}
