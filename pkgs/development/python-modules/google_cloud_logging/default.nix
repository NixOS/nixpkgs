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
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "418ae534a8044ea5fd385fc4958763d76b8f315785d7a61f264c5a04035d02d5";
  };

  checkInputs = [ pytest mock webapp2 django flask ];
  propagatedBuildInputs = [ google_api_core google_cloud_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Stackdriver Logging API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
