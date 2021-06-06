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
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-89fXmr3jHTtp8QOMFeueJwslHJ7Q6srQ/Kxsp0mLlKU=";
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
