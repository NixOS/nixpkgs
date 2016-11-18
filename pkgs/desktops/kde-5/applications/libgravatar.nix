{ akonadi
, akonadi-contacts
, boost
, cyrus_sasl
, ecm
, kcalcore
, kconfig
, kcontacts
, kdeApp
, kdelibs4support
, kdoctools
, ki18n
, kimap
, kitemmodels
, kjobwidgets
, kmime
, ktextwidgets
, kwidgetsaddons
, kxmlgui
, lib
, libical
, pimcommon
, solid
}:

kdeApp {
  name = "libgravatar";
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
    boost
    cyrus_sasl
    kcalcore
    kconfig
    kcontacts
    kdelibs4support
    kdoctools
    ki18n
    kimap
    kitemmodels
    kjobwidgets
    kmime
    ktextwidgets
    kwidgetsaddons
    kxmlgui
    libical
    pimcommon
    solid
  ];
}
