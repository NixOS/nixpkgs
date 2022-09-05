{ qtModule
, qtbase
, qtdeclarative
, qtmultimedia
, assimp
}:

qtModule {
  pname = "qt3d";
  qtInputs = [ qtbase qtdeclarative qtmultimedia ];
  propagatedBuildInputs = [ assimp ];
}
