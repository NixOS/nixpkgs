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
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "422a1bd5bded723151faeb4d1b1711f5776d2cc23d5c192cf53634eaf55c74aa";
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
