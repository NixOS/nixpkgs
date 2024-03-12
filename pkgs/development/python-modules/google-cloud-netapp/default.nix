{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-auth
, mock
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "google-cloud-netapp";
  version = "0.3.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-va5Ql8GPMLszgjjSkI6am6IGQnEqvi+YSBcTFeu254U=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    google-api-core
    google-auth
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.netapp"
    "google.cloud.netapp_v1"
  ];

  meta = with lib; {
    description = "Python Client for NetApp API";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-netapp";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-netapp-v${version}/packages/google-cloud-netapp/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
