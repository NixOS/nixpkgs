{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pandas
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-monitoring";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1debfa046ab9518d46b68712c03d86d0ddb11d1aad428aed62c6465752f2201f";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core pandas ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Stackdriver Monitoring API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
