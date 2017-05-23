{ akonadi
, akonadi-calendar
, akonadi-contacts
, boost
, calendarsupport
, ecm
, kcalcore
, kcalutils
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdgantt2
, kdoctools
, kidentitymanagement
, kitemmodels
, kjobwidgets
, kmime
, kpimtextedit
, kservice
, kxmlgui
, lib
, libical
, libkdepim
, solid
}:

kdeApp {
  name = "eventviews";
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
    boost
    calendarsupport
    kcalcore
    kcalutils
    kcompletion
    kcontacts
    kdelibs4support
    kdgantt2
    kdoctools
    kidentitymanagement
    kitemmodels
    kjobwidgets
    kmime
    kpimtextedit
    kservice
    kxmlgui
    libical
    libkdepim
    solid
  ];
  propagatedBuildInputs = [
  ];
}
