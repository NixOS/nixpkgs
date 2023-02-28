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
  version = "2.17.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RgGL9SXlmI4mcuL8phcPOCiGo2xhzRZbnpRw72U1KzI=";
  };

  propagatedBuildInputs = [
    google-api-core
    proto-plus
    protobuf
    setuptools
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requrire credentials
    "tests/system/gapic/v1/test_system_speech_v1.py"
    "tests/system/gapic/v1p1beta1/test_system_speech_v1p1beta1.py"
  ];

  pythonImportsCheck = [
    "google.cloud.speech"
    "google.cloud.speech_v1"
    "google.cloud.speech_v1p1beta1"
  ];

  meta = with lib; {
    description = "Google Cloud Speech API client library";
    homepage = "https://github.com/googleapis/python-speech";
    changelog = "https://github.com/googleapis/python-speech/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
