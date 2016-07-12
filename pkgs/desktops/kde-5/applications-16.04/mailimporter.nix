{ akonadi
, boost
, extra-cmake-modules
, karchive
, kcalcore
, kcompletion
, kconfig
, kcontacts
, kcoreaddons
, kdeApp
, kdelibs4support
, kdepimlibs
, kdoctools
, ki18n
, kitemmodels
, kjobwidgets
, kmime
, kservice
, kxmlgui
, lib
, libical
, libkdepim
, solid
}:

kdeApp {
  name = "mailimporter";
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
    karchive
    kcalcore
    kcompletion
    kconfig
    kcontacts
    kcoreaddons
    kdelibs4support
    kdepimlibs
    kdoctools
    ki18n
    kitemmodels
    kjobwidgets
    kmime
    kservice
    kxmlgui
    libical
    libkdepim
    solid
  ];
}
