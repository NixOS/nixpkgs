{ akonadi
, boost
, ecm
, lib
, kcompletion
, kdeApp
, ki18n
, kitemmodels
, kmime
, kxmlgui
}:

kdeApp {
  name = "akonadi-notes";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    ecm
  ];
  buildInputs = [
    akonadi.unwrapped
    boost
    kcompletion
    ki18n
    kitemmodels
    kmime
    kxmlgui
  ];
}
