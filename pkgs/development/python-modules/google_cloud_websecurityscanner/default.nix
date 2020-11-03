{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-websecurityscanner";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1de60f880487b898b499345f46f7acf38651f5356ebca8673116003a57f25393";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    broken = true;
    description = "Google Cloud Web Security Scanner API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
