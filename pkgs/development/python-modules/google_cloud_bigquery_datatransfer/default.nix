{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-datatransfer";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8536e8656658d349db3bd5a763ce795fe79a5bfdbd1544f406957cc42e34690b";
  };

  checkInputs = [ pytest mock ];
  requiredPythonModules = [ google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "BigQuery Data Transfer API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
