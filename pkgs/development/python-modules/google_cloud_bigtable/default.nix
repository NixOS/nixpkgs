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
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e777333cbe85888f888c034d32880bb6a602ad83d8c81a95edca7c522cf430d8";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ grpc_google_iam_v1 google_api_core google_cloud_core ];

  checkPhase = ''
    rm -r google
    pytest tests/unit -k 'not policy'
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Bigtable API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
