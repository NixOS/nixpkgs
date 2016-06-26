{ extra-cmake-modules
, kdeApp
, lib
}:

kdeApp {
  name = "kholidays";
  meta = {
    description = "Holiday calculation library";
    license = with lib.licenses; [ lgpl21Plus ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
}
