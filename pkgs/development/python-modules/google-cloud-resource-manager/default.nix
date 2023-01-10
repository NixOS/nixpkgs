{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-core
, grpc-google-iam-v1
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-resource-manager";
  version = "1.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n66Yl3xSGJNxyn2LJVGO8fuXtCKFHLRcCeoWhvxCCok=";
  };

  propagatedBuildInputs = [
    google-api-core
    google-cloud-core
    grpc-google-iam-v1
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud.resourcemanager"
    "google.cloud.resourcemanager_v3"
  ];

  meta = with lib; {
    description = "Google Cloud Resource Manager API client library";
    homepage = "https://github.com/googleapis/python-resource-manager";
    changelog = "https://github.com/googleapis/python-resource-manager/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
