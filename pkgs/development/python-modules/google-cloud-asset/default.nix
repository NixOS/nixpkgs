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
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-asset";
  version = "3.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "848b3028d87358666c50b36253404c15d0a83686700c4586475997b1478d71d5";
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

  checkInputs = [ google-cloud-testutils mock pytest-asyncio pytestCheckHook ];

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
