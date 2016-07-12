{ extra-cmake-modules
, kdeApp
, kio
, lib
}:

kdeApp {
  name = "syndication";
  meta = {
    description = "An RSS/Atom parser library";
    license = with lib.licenses; [ lgpl21Plus ];
    maintainers = with lib.maintainers; [ vandenoever ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    kio
  ];
}
