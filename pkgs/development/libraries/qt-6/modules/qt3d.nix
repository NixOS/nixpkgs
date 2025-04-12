{
  qtModule,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  assimp,
}:

qtModule {
  pname = "qt3d";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtmultimedia
    assimp
  ];
}
