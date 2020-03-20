{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-runtimeconfig";
  version = "0.30.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02075724535b3d6e1d9a6df8a2340190e195faea2f9e91f48d6ae9006993d636";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core google_cloud_core ];

  # ignore tests which require credentials or network
  checkPhase = ''
    rm -r google
    pytest tests/unit -k 'not client and not extra_headers'
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud RuntimeConfig API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
