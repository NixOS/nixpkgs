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
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zzssVnXA1xe3270yEOREJ9GdmyRPjV1F4EBelf9AQ/c=";
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
