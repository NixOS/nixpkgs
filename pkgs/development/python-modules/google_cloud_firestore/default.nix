{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-firestore";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dfe02fc0a77a4e28144c46d441553352d81498ffd8f49906b57342d06c7f5b54";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ google_api_core google_cloud_core ];

  # tests were not included with release
  # See issue https://github.com/googleapis/google-cloud-python/issues/6380
  doCheck = false;

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Firestore API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
