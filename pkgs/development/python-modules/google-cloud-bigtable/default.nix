{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-core
, grpc-google-iam-v1
, libcst
, mock
, proto-plus
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-bigtable";
  version = "2.11.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-noAGxYaQW9XBlHcHN25V/b2ScpnvjSnKdWVkAY0KbiY=";
  };

  propagatedBuildInputs = [
    google-api-core
    google-cloud-core
    grpc-google-iam-v1
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
    maintainers = with maintainers; [ costrouc ];
  };
}
