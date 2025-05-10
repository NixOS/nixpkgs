{
  qtModule,
  fetchpatch,
  qtbase,
  qtdeclarative,
  protobuf,
  grpc,
}:

qtModule {
  pname = "qtgrpc";

  patches = [
    (fetchpatch {
      name = "new-protobuf.patch";
      url = "https://github.com/qt/qtgrpc/commit/514769d1bd595d0e54bbe34c0bd167636d4825dc.diff";
      hash = "sha256-juNSijNlR6PHxiEVx72vMBSvcWYfR/T/yvpxAF+ZAKE=";
    })
  ];

  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  buildInputs = [
    protobuf
    grpc
  ];
}
