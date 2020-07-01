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
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0smpvzdbz3ih3vc0nmn9619xa40mmqk9rs9ic1mwwyh1iyi44waz";
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
