{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-core
, grpc_google_iam_v1
, libcst
, mock
, proto-plus
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "google-cloud-bigtable";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-89fXmr3jHTtp8QOMFeueJwslHJ7Q6srQ/Kxsp0mLlKU=";
  };

  propagatedBuildInputs = [
    google-api-core
    google-cloud-core
    grpc_google_iam_v1
    libcst
    proto-plus
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  checkPhase = ''
    # Prevent google directory from shadowing google imports
    rm -r google
  '';

  disabledTests = [
    "policy"
  ];

  pythonImportsCheck = [
    "google.cloud.bigtable_admin_v2"
    "google.cloud.bigtable_v2"
    "google.cloud.bigtable"
  ];

  meta = with lib; {
    description = "Google Cloud Bigtable API client library";
    homepage = "https://github.com/googleapis/python-bigtable";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
