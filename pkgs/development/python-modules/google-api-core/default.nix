{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  google-auth,
  googleapis-common-protos,
  grpcio,
  grpcio-gcp,
  grpcio-status,
  opentelemetry-api,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-api-core";
  version = "2.43.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-api-core-v${finalAttrs.version}";
    hash = "sha256-sCC5tXBWQt1eeCCJP8NmmGrQvQYI7Djh4YyLR82Sfp4=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/google-api-core";

  build-system = [ setuptools ];

  dependencies = [
    googleapis-common-protos
    google-auth
    opentelemetry-api
    protobuf
    proto-plus
    requests
  ];

  pythonRelaxDeps = [
    "opentelemetry-api"
    "protobuf"
  ];

  optional-dependencies = {
    async_rest = [ google-auth ] ++ google-auth.optional-dependencies.aiohttp;
    grpc = [
      grpcio
      grpcio-status
    ];
    grpcgcp = [ grpcio-gcp ];
    grpcio-gcp = [ grpcio-gcp ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pytestFlags = [
    "-Wignore::pytest.PytestRemovedIn10Warning"
  ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  disabledTests = [
    # Those grpc_helpers tests are failing
    "test_wrap_unary_errors"
    "test_wrap_stream_errors_raised"
    "test_wrap_stream_errors_read"
    "test_wrap_stream_errors_aiter"
    "test_wrap_stream_errors_write"
    "test_wrap_unary_errors"
    "test___next___w_rpc_error"
    "test_wrap_stream_errors_invocation"
    "test_wrap_stream_errors_iterator_initialization"
    "test_wrap_stream_errors_during_iteration"
    "test_exception_with_error_code"
  ];

  pythonImportsCheck = [ "google.api_core" ];

  meta = {
    description = "Core Library for Google Client Libraries";
    longDescription = ''
      This library is not meant to stand-alone. Instead it defines common
      helpers used by all Google API clients.
    '';
    homepage = "https://github.com/googleapis/google-cloud-python";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${finalAttrs.src.tag}/packages/google-api-core/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sarahec
    ];
  };
})
