{
  qtModule,
  lib,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtpim";

  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];

  cmakeFlags = [
    # Does not take part in the release cycles
    (lib.cmakeBool "QT_NO_PACKAGE_VERSION_CHECK" true)
  ];
}
