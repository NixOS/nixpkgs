{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-websecurityscanner";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "26a29657e20fda4302275b92c84c16228381998797e203f85d612f93d4c62358";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Web Security Scanner API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
