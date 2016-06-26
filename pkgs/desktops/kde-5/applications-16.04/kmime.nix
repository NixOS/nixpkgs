{ extra-cmake-modules
, kcodecs
, kdeApp
, ki18n
, lib
}:

kdeApp {
  name = "kmime";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kcodecs
    ki18n
  ];
}
