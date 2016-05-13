{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, kmime
}:

kdeApp {
  name = "kmbox";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  propagatedbuildInputs = [
    kmime
  ];

  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
