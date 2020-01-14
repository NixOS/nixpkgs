{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-firestore";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7fec7b523ab5e1f87721ca61181114818579bb4d17de768a3993811c9d2aacfe";
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
