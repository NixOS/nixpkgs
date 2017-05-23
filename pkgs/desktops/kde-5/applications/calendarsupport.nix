{ akonadi
, akonadi-calendar
, akonadi-contacts
, akonadi-mime
, boost
, cyrus_sasl
, ecm
, kcalcore
, kcalutils
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdepim-apps-libs
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
    ecm
  ];
  buildInputs = [
    akonadi.unwrapped
    akonadi-calendar
    akonadi-contacts
    akonadi-mime
    boost
    cyrus_sasl
    kcalcore
    kcalutils
    kcompletion
    kcontacts
    kdelibs4support
    kdepim-apps-libs
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
