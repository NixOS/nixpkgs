{
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  grpc-interceptor,
  grpcio,
  httpx,
  lib,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  rustc,
  rustPlatform,
  syrupy,
}:

buildPythonPackage rec {
  pname = "qcs-api-client-common";
  version = "0.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "qcs-api-client-rust";
    tag = "common/v${version}";
    hash = "sha256-ksB71Vd9PbKAHll2Y5VrCspsyUyhXwthHl2yVl6MQ7U=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-QvMeCzpHGMVjqYs0i3gpzY6Zk4rGiXyTopzaQMLWBcA=";
  };

  buildAndTestSubdir = "qcs-api-client-common";

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  dependencies = [
    grpc-interceptor
    grpcio
    httpx
  ];

  preCheck = ''
    cd ${buildAndTestSubdir}
  '';

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/rigetti/qcs-api-client-rust/blob/${src.tag}/qcs-api-client-common/CHANGELOG-py.md";
    description = "Contains core QCS client functionality and middleware implementations";
    homepage = "https://github.com/rigetti/qcs-api-client-rust/tree/main/qcs-api-client-common";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
