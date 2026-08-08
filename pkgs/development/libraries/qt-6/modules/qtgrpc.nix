{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtdeclarative,
  protobuf,
  grpc,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtgrpc";

  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  buildInputs = [
    protobuf
    grpc
  ];

  nativeBuildInputs = [
    protobuf # for protoc executable
  ];

  # Conditional is required to prevent infinite recursion during a cross build
  cmakeFlags =
    lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      "-DQt6GrpcTools_DIR=${pkgsBuildBuild.qt6.qtgrpc}/lib/cmake/Qt6GrpcTools"
      "-DQt6ProtobufTools_DIR=${pkgsBuildBuild.qt6.qtgrpc}/lib/cmake/Qt6ProtobufTools"
    ]
    ++ [
      "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
      "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    ];

}
