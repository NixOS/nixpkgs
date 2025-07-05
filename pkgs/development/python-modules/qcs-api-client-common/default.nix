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
  pythonAtLeast,
  rustc,
  rustPlatform,
  syrupy,
}:

buildPythonPackage rec {
  pname = "qcs-api-client-common";
  version = "0.11.8";
  pyproject = true;

  # error: the configured Python interpreter version (3.13) is newer than PyO3's maximum supported version (3.12)
  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "qcs-api-client-rust";
    tag = "common/v${version}";
    hash = "sha256-IJaclIGuLWyTaVnnK1MblSZjIqjaMjLCFfY1CLn6Rao=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-luLg4VR7Nwm6g1UYckKmN9iy1MvNezYh9g21ADMX/yU=";
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
    changelog = "https://github.com/rigetti/qcs-api-client-rust/blob/${src.tag}/qcs-api-client-common/CHANGELOG-py.md";
    description = "Contains core QCS client functionality and middleware implementations";
    homepage = "https://github.com/rigetti/qcs-api-client-rust/tree/main/qcs-api-client-common";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
