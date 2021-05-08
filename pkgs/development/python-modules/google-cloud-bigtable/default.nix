{ lib
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
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "90bd53a19c33c34101b8567c82a6dc0386af4118d70e1ad69b49375358a21aa6";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ grpc_google_iam_v1 google-api-core google-cloud-core ];

  checkPhase = ''
    rm -r google
    pytest tests/unit -k 'not policy'
  '';

  meta = with lib; {
    description = "Google Cloud Bigtable API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
