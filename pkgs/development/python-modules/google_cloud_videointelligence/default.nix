{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-videointelligence";
  version = "1.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de6fe53bdaf66aa8e2c1f34b26af24c479a876619b5c667d009fbd9700dd89f7";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Video Intelligence API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
