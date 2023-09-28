{ qtModule
, qtbase
, qtdeclarative
, protobuf
, grpc
, patches ? []
}:

qtModule {
  pname = "qtgrpc";
  propagatedBuildInputs = [ qtbase qtdeclarative ];
  buildInputs = [ protobuf grpc ];
  inherit patches;
}
