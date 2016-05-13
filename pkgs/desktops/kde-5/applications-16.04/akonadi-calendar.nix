{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, kio
, kwallet
}:

kdeApp {
  name = "akonadi-calendar";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];

  propagatedbuildInputs = [
    kio
    kwallet

  ];


  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
