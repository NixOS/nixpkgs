{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, mock
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "google-cloud-speech";
  version = "2.23.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H4aDIHCF3cpsXgZIly+KBik30w5zqlVSDwgPSVMse/8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Test requires project ID
    "test_list_phrase_set"
  ];

  pythonImportsCheck = [
    "google.cloud.speech"
    "google.cloud.speech_v1"
    "google.cloud.speech_v1p1beta1"
  ];

  meta = with lib; {
    description = "Google Cloud Speech API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-speech";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-speech-v${version}/packages/google-cloud-speech/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
