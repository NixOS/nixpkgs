{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, libcst
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-speech";
  version = "2.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc85ae6694c9a1e02046364776b9f2401a3826ddc7b532b32c316559ff4f1afa";
  };

  propagatedBuildInputs = [ libcst google-api-core proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  pytestFlagsArray = [
    # requrire credentials
    "--ignore=tests/system/gapic/v1/test_system_speech_v1.py"
    "--ignore=tests/system/gapic/v1p1beta1/test_system_speech_v1p1beta1.py"
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
