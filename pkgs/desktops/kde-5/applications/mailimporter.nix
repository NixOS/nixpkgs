{ akonadi
, akonadi-contacts
, akonadi-mime
, boost
, ecm
, karchive
, kcalcore
, kcompletion
, kconfig
, kcontacts
, kcoreaddons
, kdeApp
, kdelibs4support
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
    ecm
  ];
  buildInputs = [
    akonadi.unwrapped
    akonadi-contacts
    akonadi-mime
    boost
    karchive
    kcalcore
    kcompletion
    kconfig
    kcontacts
    kcoreaddons
    kdelibs4support
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
