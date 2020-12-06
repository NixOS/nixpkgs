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
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ebf3b0bcb483e066dfe73679e019e2d7b8c1652e26984702cf5e3f020592f6a";
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
