{ extra-cmake-modules
, kdeApp
, kio
, lib
}:

kdeApp {
  name = "syndication";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kio
  ];
}
