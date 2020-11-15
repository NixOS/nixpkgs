{ stdenv, buildPythonPackage, fetchPypi, pytestCheckHook, pythonOlder
, google_api_core, libcst, mock, proto-plus, pytest-asyncio }:

buildPythonPackage rec {
  pname = "google-cloud-websecurityscanner";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1de60f880487b898b499345f46f7acf38651f5356ebca8673116003a57f25393";
  };

  disabled = pythonOlder "3.6";

  checkInputs = [ mock pytest-asyncio pytestCheckHook ];
  propagatedBuildInputs = [ google_api_core libcst proto-plus ];

  meta = with stdenv.lib; {
    description = "Google Cloud Web Security Scanner API client library";
    homepage = "https://github.com/googleapis/python-websecurityscanner";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
