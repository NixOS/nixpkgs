{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-dlp";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ccf04209f96b4759d8ed76da2c916a456386836caacd47ce01b6344f5b8f212";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ enum34 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud Data Loss Prevention (DLP) API API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
