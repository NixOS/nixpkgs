{ stdenv
, buildPythonPackage
, fetchPypi
, google_cloud_logging
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-error-reporting";
  version = "0.30.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "29d04cb6cc2053468addb78351b841df00cb56066e89b6aec0970cb003dd2fab";
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
