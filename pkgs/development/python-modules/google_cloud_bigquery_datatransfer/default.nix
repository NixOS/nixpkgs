{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-datatransfer";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ef431c0747d92dd5d5d4038aab96215dfd20c59235ece99a96d8329792cbcdb";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "BigQuery Data Transfer API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
