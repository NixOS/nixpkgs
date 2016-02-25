{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, kcodecs
}:

kdeApp {
  name = "kmime";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  buildInputs = [
    kcodecs
  ];

  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
