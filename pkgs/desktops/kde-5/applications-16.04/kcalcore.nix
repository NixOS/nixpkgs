{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, kdelibs4support
, libical
}:

kdeApp {
  name = "kcalcore";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  propagatedbuildInputs = [
    kdelibs4support
    libical
  ];

  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
