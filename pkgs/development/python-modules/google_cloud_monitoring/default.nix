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
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "30632fa7aad044a3b4e2b662e6ba99f29f60064c1cfc88bbf4d175c1a12ced66";
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
