{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, kcoreaddons
, kconfig
, kcodecs
}:

kdeApp {
  name = "kcontacts";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];

  propagatedbuildInputs = [
    kcodecs
    kcoreaddons
    kconfig
  ];

  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
