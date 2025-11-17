{
  qtModule,
  qtbase,
  qtserialport,
}:

qtModule {
  pname = "qtserialbus";
  propagatedBuildInputs = [
    qtbase
    qtserialport
  ];
  meta.mainProgram = "canbusutil";
}
