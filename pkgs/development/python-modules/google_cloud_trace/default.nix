{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-trace";
  version = "0.24.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c342dbd9daf5375b3f8bb94302b7ea9a9946f76684e457a38ff0d420b3b6556";
  };

  checkInputs = [ pytest mock ];
  requiredPythonModules = [ google_api_core google_cloud_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Stackdriver Trace API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
