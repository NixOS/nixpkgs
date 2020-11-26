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
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e9b904ebe651c4699829f7379706a4cd00b19b6d72b24e78a4dca9bba3bb52ad";
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
