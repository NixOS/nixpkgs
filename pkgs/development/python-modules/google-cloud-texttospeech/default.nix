{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, google-api-core
, libcst
, mock
, proto-plus
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-texttospeech";
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e81beafa612f288fe74db55dd3a409f96cb01d2bac117bcd06a4e5b427d81476";
  };

  propagatedBuildInputs = [ libcst google-api-core proto-plus ];

  checkInputs = [ mock pytest-asyncio pytestCheckHook ];

  disabledTests = [
    # Disable tests that require credentials
    "test_list_voices"
    "test_synthesize_speech"
  ];

  pythonImportsCheck = [
    "google.cloud.texttospeech"
    "google.cloud.texttospeech_v1"
    "google.cloud.texttospeech_v1beta1"
  ];

  meta = with lib; {
    description = "Google Cloud Text-to-Speech API client library";
    homepage = "https://github.com/googleapis/python-texttospeech";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
