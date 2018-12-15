{ stdenv
, buildPythonPackage
, fetchPypi
, grpc_google_iam_v1
, grpcio-gcp
, google_api_core
, google_cloud_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-spanner";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7140e1cb43fbf670521112f03822b63d15fbcbd2830c7cfa1b868836e04b6b4";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ grpcio-gcp grpc_google_iam_v1 google_api_core google_cloud_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud Spanner API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
