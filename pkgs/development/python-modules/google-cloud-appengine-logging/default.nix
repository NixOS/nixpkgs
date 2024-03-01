{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, grpc-google-iam-v1
, mock
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "google-cloud-appengine-logging";
  version = "1.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E03mSoQBfP4mpLOjJbzJtKLboF+cnTkC7iS0sfo+KK8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    google-api-core
    grpc-google-iam-v1
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.appengine_logging"
    "google.cloud.appengine_logging_v1"
  ];

  meta = with lib; {
    description = "Appengine logging client library";
    homepage = "https://github.com/googleapis/python-appengine-logging";
    changelog = "https://github.com/googleapis/python-appengine-logging/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
