{ extra-cmake-modules
, kdeApp
, ki18n
, lib
}:

kdeApp {
  name = "kdgantt2";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    ki18n
  ];
}
