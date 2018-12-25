{ stdenv
, buildPythonPackage
, fetchPypi
, grpc_google_iam_v1
, google_api_core
, google_cloud_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-bigtable";
  version = "0.31.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6c8572697b5fdc7fcb95d88f87b8c84cea5a7aef2d57d3de0d6a9e2b0e8424f";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ grpc_google_iam_v1 google_api_core google_cloud_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Bigtable API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
