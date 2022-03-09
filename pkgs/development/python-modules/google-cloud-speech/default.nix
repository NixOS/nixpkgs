{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, libcst
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-speech";
  version = "2.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JxhIC4OMsXjdJYNDomEhmHPUCzveFS0oeDWsX/wd5zA=";
  };

  propagatedBuildInputs = [
    libcst
    google-api-core
    proto-plus
  ];

  checkInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
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
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
