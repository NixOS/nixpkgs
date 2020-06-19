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
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c98690833ee2e6341a4b802f278ba17d582ce58eb2e73152516ebc77522d82d7";
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
