{ qtModule
, qtbase
, qtdeclarative
, protobuf
, grpc
}:

qtModule {
  pname = "qtgrpc";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
  buildInputs = [ protobuf grpc ];
}
