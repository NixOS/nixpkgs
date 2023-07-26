{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-testutils
, mock
, proto-plus
, pandas
, pytestCheckHook
, pytest-asyncio
, protobuf
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-monitoring";
  version = "2.15.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CGqEWjSm4QWrijpICTkupjZ6ZbKLdWHCYQFTSocF7Tc=";
  };

  propagatedBuildInputs = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  passthru.optional-dependencies = {
    pandas = [
      pandas
    ];
  };

  nativeCheckInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ] ++ passthru.optional-dependencies.pandas;

  disabledTests = [
    # requires credentials
    "test_list_monitored_resource_descriptors"
  ];

  pythonImportsCheck = [
    "google.cloud.monitoring"
    "google.cloud.monitoring_v3"
  ];

  meta = with lib; {
    description = "Stackdriver Monitoring API client library";
    homepage = "https://github.com/googleapis/python-monitoring";
    changelog = "https://github.com/googleapis/python-monitoring/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
