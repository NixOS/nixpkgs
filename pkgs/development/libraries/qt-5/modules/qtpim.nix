{ qtModule
, lib
, qtbase
, qtdeclarative
}:

qtModule {
  pname = "qtpim";

  outputs = [
    "out"
    "dev"
  ];

  qtInputs = [
    qtbase
    qtdeclarative
  ];

  qmakeFlags = [
    "CONFIG+=git_build"
  ];

  meta = {
    maintainers = with lib.maintainers; [ OPNA2608 ];
  };
}
