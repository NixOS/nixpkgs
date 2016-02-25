{ kdeApp
, lib
, extra-cmake-modules
, kdoctools
, makeQtWrapper
, kcmutils
, kwallet
, kmime
, akonadi
}:

kdeApp {
  name = "kmailtransport";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
    makeQtWrapper
  ];

  buildInputs = [
    kcmutils
    kmime
    kwallet
    akonadi

  ];

  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
