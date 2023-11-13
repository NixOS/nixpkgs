{ qtModule
, qtbase
, qtdeclarative
, protobuf
, grpc
, patches ? []
}:

qtModule {
  pname = "qtgrpc";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ protobuf grpc ];
  inherit patches;
}
