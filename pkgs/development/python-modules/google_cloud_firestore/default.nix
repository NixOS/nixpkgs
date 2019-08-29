{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, google_cloud_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-firestore";
  version = "0.31.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5349d1a112dc8ff1b96d400a04ab18949503b542c72f526847e2066eef6cbc25";
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
