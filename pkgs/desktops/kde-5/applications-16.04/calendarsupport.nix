{ akonadi
, akonadi-calendar
, boost
, cyrus_sasl
, extra-cmake-modules
, kcalcore
, kcalutils
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdepim-apps-libs
, kdepimlibs
, kdoctools
, kholidays
, kidentitymanagement
, kimap
, kitemmodels
, kjobwidgets
, kmime
, kpimtextedit
, kservice
, kxmlgui
, lib
, libical
, pimcommon
, solid
}:

kdeApp {
  name = "calendarsupport";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    akonadi
    akonadi-calendar
    boost
    cyrus_sasl
    kcalcore
    kcalutils
    kcompletion
    kcontacts
    kdelibs4support
    kdepim-apps-libs
    kdepimlibs
    kdoctools
    kholidays
    kidentitymanagement
    kimap
    kitemmodels
    kjobwidgets
    kmime
    kpimtextedit
    kservice
    kxmlgui
    libical
    pimcommon
    solid
  ];
}
