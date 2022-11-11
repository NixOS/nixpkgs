{ qtModule
, qtdeclarative
}:

qtModule {
  pname = "qtdoc";
  qtInputs = [ qtdeclarative ];
  outputs = [ "out" ];
}
