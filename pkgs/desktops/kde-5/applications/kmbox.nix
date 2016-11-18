{ ecm
, kdeApp
, kmime
, lib
}:

kdeApp {
  name = "kmbox";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    ecm
  ];
  buildInputs = [
    kmime
  ];
}
