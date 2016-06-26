{ akonadi
, akonadi-calendar
, boost
, calendarsupport
, extra-cmake-modules
, kcalcore
, kcalutils
, kcompletion
, kcontacts
, kdeApp
, kdelibs4support
, kdepimlibs
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
    extra-cmake-modules
  ];
  buildInputs = [
    akonadi
    akonadi-calendar
    boost
    calendarsupport
    kcalcore
    kcalutils
    kcompletion
    kcontacts
    kdelibs4support
    kdepimlibs
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
