{ stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder
, google_api_core, libcst, mock, proto-plus, pytest-asyncio, }:

buildPythonPackage rec {
  pname = "google-cloud-texttospeech";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbbd397e72b6189668134f3c8e8c303198188334a4e6a5f77cc90c3220772f9e";
  };

  disabled = pythonOlder "3.5";

  checkInputs = [ mock pytest-asyncio pytestCheckHook ];
  propagatedBuildInputs = [ google_api_core libcst proto-plus ];

  # Disable tests that require credentials
  disabledTests = ["test_synthesize_speech" "test_list_voices"];

  meta = with stdenv.lib; {
    description = "Google Cloud Text-to-Speech API client library";
    homepage = "https://github.com/googleapis/python-texttospeech";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
