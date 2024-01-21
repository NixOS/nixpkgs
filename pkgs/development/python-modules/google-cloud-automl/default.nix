{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-storage
, google-cloud-testutils
, libcst
, mock
, pandas
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "google-cloud-automl";
  version = "2.12.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IvemHgS0qbA9UE7y22aD30YqAy2lP+P7ssNvUlB0q7U=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  passthru.optional-dependencies = {
    libcst = [
      libcst
    ];
    pandas = [
      pandas
    ];
    storage = [
      google-cloud-storage
    ];
  };

  nativeCheckInputs = [
    google-cloud-storage
    google-cloud-testutils
    mock
    pandas
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    # do not shadow imports
    rm -r google
  '';

  disabledTests = [
    # Test requires credentials
    "test_prediction_client_client_info"
    # Test requires project ID
    "test_list_models"
  ];

  pythonImportsCheck = [
    "google.cloud.automl"
    "google.cloud.automl_v1"
    "google.cloud.automl_v1beta1"
  ];

  meta = with lib; {
    description = "Cloud AutoML API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-automl";
    changelog = "https://github.com/googleapis/google-cloud-python/tree/google-cloud-automl-v${version}/packages/google-cloud-automl";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
