{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-firestore";
  version = "0.30.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f990572ace890867bbbc63c9d700c1d2635ba4c799e05f30b6fdca490021243";
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
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
