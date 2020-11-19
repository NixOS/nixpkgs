{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-datastore";
  version = "1.15.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3da44b4c8230a83e69dd9429324cca9d3000ee8a8bb11f3b005c7837fcd844b3";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core google_cloud_core ];

  checkPhase = ''
    rm -r google
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Datastore API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
