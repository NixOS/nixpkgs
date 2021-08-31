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
, pytest
, pytest-asyncio
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-asset";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd1fe84efd2e45042d95c7e5713e0a0365ec8138df062c07fab761233202ab6f";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"google-cloud-org-policy >= 0.1.2, < 0.2.0dev"' '"google-cloud-org-policy >= 0.1.2"'
  '';

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
