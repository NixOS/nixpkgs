{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, protobuf
, proto-plus
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-os-config";
  version = "1.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CLZC9Iub3LWvDPhetxlHorccRUritd+YzTI/MF1hHrY=";
  };

  propagatedBuildInputs = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.osconfig"
  ];

  disabledTests = [
    "test_patch_deployment"
    "test_patch_job"
  ];

  meta = with lib; {
    description = "Google Cloud OS Config API client library";
    homepage = "https://github.com/googleapis/python-os-config";
    changelog = "https://github.com/googleapis/python-os-config/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
