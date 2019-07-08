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
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a70201ca9f3972ff0e3272c5628b22ed9227e10ac00e570c28087377733632df";
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
