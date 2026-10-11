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
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "qcs-api-client-common";
  version = "0.19.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "qcs-api-client-rust";
    tag = "common/v${version}";
    hash = "sha256-60WzBbvkb+71VaIlgh6Nw/CN4B2e3qEPqpXUeiv6lrc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-KOWEQtF7uveE7AgguuXlksDAQDZ9GhctP1OQhTjCQwk=";
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
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # LoadError
    "test_sync_method_from_async_context"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # asyncio.Future() in sync fixture has no implicit event loop on 3.14
    "test_refresh_interceptor"
  ];

  meta = {
    changelog = "https://github.com/rigetti/qcs-api-client-rust/blob/${src.tag}/qcs-api-client-common/CHANGELOG-py.md";
    description = "Contains core QCS client functionality and middleware implementations";
    homepage = "https://github.com/rigetti/qcs-api-client-rust/tree/main/qcs-api-client-common";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
