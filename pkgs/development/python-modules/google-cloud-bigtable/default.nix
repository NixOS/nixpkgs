{ stdenv
, buildPythonPackage
, fetchPypi
, grpc_google_iam_v1
, google-api-core
, google-cloud-core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-bigtable";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ace4ff7c6e00fb7d86963503615db85336b6484339f5774bd8c589df224772a8";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ grpc_google_iam_v1 google-api-core google-cloud-core ];

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
