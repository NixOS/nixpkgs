{
  qtModule,
  qtbase,
}:

qtModule {
  pname = "qtlanguageserver";
  propagatedBuildInputs = [ qtbase ];

  # Doesn't have version set
  dontCheckQtModuleVersion = true;
}
