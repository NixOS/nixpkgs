{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, libcst
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-language";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "123vqfrn7pyn3ia7cmhx8bgafd4gxxlmhf33s3vgspyjck6sprxb";
  };

  propagatedBuildInputs = [ google_api_core libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  pythonImportsCheck = [
    "google.cloud.language"
    "google.cloud.language_v1"
    "google.cloud.language_v1beta2"
  ];

  meta = with stdenv.lib; {
    description = "Google Cloud Natural Language API client library";
    homepage = "https://github.com/googleapis/python-language";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
