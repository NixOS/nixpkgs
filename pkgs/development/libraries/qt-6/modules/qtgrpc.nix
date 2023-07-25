{ qtModule
, qtbase
, qtdeclarative
, protobuf
, grpc
}:

qtModule {
  pname = "qtgrpc";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ protobuf grpc ];
}
