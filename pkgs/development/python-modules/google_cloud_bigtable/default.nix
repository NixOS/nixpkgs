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
  version = "0.32.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "40d1fc8009c228f70bd0e2176e73a3f101051ad73889b3d25a5df672c029a8bd";
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
