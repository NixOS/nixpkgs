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
  version = "1.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c12d4421df8e4e77b5e029b1341ae80d180cfda0f9cbef417f36438630cc35f";
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
