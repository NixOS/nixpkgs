{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  grpc-google-iam-v1,
  libcst,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "google-cloud-iot";
  version = "2.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pLQgcwR89F+9jcSDtW/5+6Gy+Wk7XQf4iD49vDPkN9U=";
  };

  propagatedBuildInputs = [
    google-api-core
    grpc-google-iam-v1
    libcst
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  # including_default_value_fields was deprecated, the new version is called
  # always_print_fields_with_no_presence
  postPatch = ''
    substituteInPlace "tests/unit/gapic/iot_v1/test_device_manager.py" \
      --replace-fail "including_default_value_fields" "always_print_fields_with_no_presence"
    substituteInPlace "google/cloud/iot_v1/services/device_manager/transports/rest.py" \
      --replace-fail "including_default_value_fields" "always_print_fields_with_no_presence"
  '';

  disabledTests = [
    # requires credentials
    "test_list_device_registries"
  ];

  pythonImportsCheck = [
    "google.cloud.iot"
    "google.cloud.iot_v1"
  ];

  meta = with lib; {
    description = "Cloud IoT API API client library";
    homepage = "https://github.com/googleapis/python-iot";
    changelog = "https://github.com/googleapis/python-iot/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
