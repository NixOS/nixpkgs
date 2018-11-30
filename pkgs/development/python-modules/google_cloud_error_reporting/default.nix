{ stdenv
, buildPythonPackage
, fetchPypi
, google_cloud_logging
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-error-reporting";
  version = "0.30.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "768a5c3ed7a96b60f051717c1138e561493ab0ef4dd4acbcf9e2b1cc2d09e06a";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_cloud_logging ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Stackdriver Error Reporting API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
