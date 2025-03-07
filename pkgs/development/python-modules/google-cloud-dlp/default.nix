{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-cloud-testutils,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-dlp";
  version = "3.18.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R0CMx16DmMfc6Tw/YqPthYKyDxJcyODdMxAVrj62L34=";
  };

  nativeBuildInputs = [ setuptools ];

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
    # Test requires credentials
    "test_inspect_content"
    "test_list_dlp_jobs"
  ];

  pythonImportsCheck = [
    "google.cloud.dlp"
    "google.cloud.dlp_v2"
  ];

  meta = with lib; {
    description = "Cloud Data Loss Prevention (DLP) API API client library";
    homepage = "https://github.com/googleapis/python-dlp";
    changelog = "https://github.com/googleapis/python-dlp/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
