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
  version = "1.15.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KNM4wASyfgoBqhXa5k+8tf+AN9VljHDDK0U849N5qHI=";
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
    # Test requires a project ID
    "test_patch_deployment"
    "test_patch_job"
    "test_list_patch_jobs"
  ];

  meta = with lib; {
    description = "Google Cloud OS Config API client library";
    homepage = "https://github.com/googleapis/python-os-config";
    changelog = "https://github.com/googleapis/python-os-config/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
