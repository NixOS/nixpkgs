{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, grpc_google_iam_v1
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-pubsub";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8d098ebd208d00c8f3bb55eefecd8553e7391d59700426a97d35125f0dcb248";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ enum34 grpc_google_iam_v1 google_api_core ];

  # tests don't clean up file descriptors correctly
  doCheck = false;
  checkPhase = ''
    pytest tests/unit
  '';

  pythonImportsCheck = [ "google.cloud.pubsub" ];

  meta = with stdenv.lib; {
    description = "Google Cloud Pub/Sub API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
