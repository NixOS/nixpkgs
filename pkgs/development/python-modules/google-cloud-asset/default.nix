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
, proto-plus
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-asset";
  version = "3.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DMRBAzGlByjcdLr/HnVxFxbNWK1TbYFpYKEjDdzfEeg=";
  };

  propagatedBuildInputs = [
    grpc-google-iam-v1
    google-api-core
    google-cloud-access-context-manager
    google-cloud-org-policy
    google-cloud-os-config
    libcst
    proto-plus
  ];

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
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
