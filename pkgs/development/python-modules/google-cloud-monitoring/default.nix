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
  version = "2.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-w6BCbs0lpw2lOyqQedcXMSKahJak7a6NN4Xsy7+CjVs=";
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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
