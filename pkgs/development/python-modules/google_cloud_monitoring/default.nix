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
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2feee2cc56b60ed1316175af0974668041c6480803542d3711e4365882dc79cd";
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
