{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-testutils
, mock
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-trace";
  version = "1.11.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pn2ofYfcHBxAw7IK5lKqf1AGj8e+DU8W++9XVFPZ5Ws=";
  };

  propagatedBuildInputs = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # require credentials
    "test_batch_write_spans"
    "test_list_traces"
  ];

  pythonImportsCheck = [
    "google.cloud.trace"
    "google.cloud.trace_v1"
    "google.cloud.trace_v2"
  ];

  meta = with lib; {
    description = "Cloud Trace API client library";
    homepage = "https://github.com/googleapis/python-trace";
    changelog = "https://github.com/googleapis/python-trace/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
