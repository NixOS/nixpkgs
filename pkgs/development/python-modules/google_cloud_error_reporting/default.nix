{ stdenv
, buildPythonPackage
, fetchPypi
, google_cloud_logging
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-error-reporting";
  version = "0.33.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "845c4d7252f21403a5634a4047c3d77a645df92f6724911a5faf6f5e1bba51fd";
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
