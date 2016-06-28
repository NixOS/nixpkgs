{ akonadi
, boost
, cyrus_sasl
, extra-cmake-modules
, kcalcore
, kconfig
, kcontacts
, kdeApp
, kdelibs4support
, kdepimlibs
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
    extra-cmake-modules
  ];
  buildInputs = [
    akonadi
    boost
    cyrus_sasl
    kcalcore
    kconfig
    kcontacts
    kdelibs4support
    kdepimlibs
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
