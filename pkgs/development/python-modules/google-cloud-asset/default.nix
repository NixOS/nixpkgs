{ lib
, buildPythonPackage
, fetchPypi
, grpc-google-iam-v1
, google-api-core
, google-cloud-access-context-manager
, google-cloud-org-policy
, google-cloud-os-config
, google-cloud-testutils
, libcst
, protobuf
, proto-plus
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-asset";
  version = "3.14.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pwn9fU1kniouSQbDSEDlANkeoBN4gzTeuuhnuD5Puq8=";
  };

  propagatedBuildInputs = [
    grpc-google-iam-v1
    google-api-core
    google-cloud-access-context-manager
    google-cloud-org-policy
    google-cloud-os-config
    libcst
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  passthru.optional-dependencies = {
    libcst = [
      libcst
    ];
  };

  checkInputs = [
    google-cloud-testutils
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.asset"
    "google.cloud.asset_v1"
    "google.cloud.asset_v1p1beta1"
    "google.cloud.asset_v1p2beta1"
    "google.cloud.asset_v1p4beta1"
    "google.cloud.asset_v1p5beta1"
  ];

  meta = with lib; {
    description = "Python Client for Google Cloud Asset API";
    homepage = "https://github.com/googleapis/python-asset";
    changelog = "https://github.com/googleapis/python-asset/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
