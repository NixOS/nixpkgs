{ akonadi
, boost
, ecm
, lib
, kdeApp
, kdbusaddons
, kio
, kitemmodels
, kmime
}:

kdeApp {
  name = "akonadi-mime";
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
    kdbusaddons
    kio
    kitemmodels
    kmime
  ];
}
