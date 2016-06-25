{ extra-cmake-modules
, kdeApp
, lib
}:

kdeApp {
  name = "kholidays";
  meta = {
    license = with lib.licenses; [ lgpl2 ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
}
