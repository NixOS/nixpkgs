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
  version = "0.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "qcs-api-client-rust";
    rev = "refs/tags/common/v${version}";
    hash = "sha256-WXTqzdbBZmBj/+mVK/watOuaq/WqKtaMVhp+ogjmhqM=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hyper-proxy-0.9.1" = "sha256-P9/qMHfq56rkQoBQF3o/SmbOfcePcFf8yh1YQve3oGM=";
    };
  };

  # FIXME use
  #     buildAndTestSubdir = "qcs-api-client-common";
  # instead, which makes the tests fail
  postPatch = ''
    cd qcs-api-client-common
  '';
  cargoRoot = "..";

  build-system = [ rustPlatform.maturinBuildHook ];

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  dependencies = [
    grpc-interceptor
    grpcio
    httpx
  ];

  preCheck = ''
    # import from $out
    rm -r qcs_api_client_common
  '';

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/rigetti/qcs-api-client-rust/blob/${src.rev}/qcs-api-client-common/CHANGELOG-py.md";
    description = "Contains core QCS client functionality and middleware implementations";
    homepage = "https://github.com/rigetti/qcs-api-client-rust/tree/main/qcs-api-client-common";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
