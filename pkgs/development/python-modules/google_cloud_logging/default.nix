{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_core
, pytest
, mock
, webapp2
, django
, flask
}:

buildPythonPackage rec {
  pname = "google-cloud-logging";
  version = "1.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb0d4af9d684eb8a416f14c39d9fa6314be3adf41db2dd8ee8e30db9e8853d90";
  };

  checkInputs = [ pytest mock webapp2 django flask ];
  propagatedBuildInputs = [ google_api_core google_cloud_core ];

  checkPhase = ''
    rm -r google
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Stackdriver Logging API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
