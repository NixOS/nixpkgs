{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, google-cloud-core
, grpcio
, grpc-google-iam-v1
, libcst
, mock
, proto-plus
, protobuf
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-bigtable";
  version = "2.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-idnWz7o7RuOAZbY+H5STVAVa1rexThDY3Zb5eaI10Ao=";
  };

  propagatedBuildInputs = [
    google-api-core
    google-cloud-core
    grpc-google-iam-v1
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  passthru.optional-dependencies = {
    libcst = [
      libcst
    ];
  };

  nativeCheckInputs = [
    grpcio
    mock
    pytestCheckHook
  ];

  checkPhase = ''
    # Prevent google directory from shadowing google imports
    rm -r google
  '';

  disabledTests = [
    "policy"
  ];

  pythonImportsCheck = [
    "google.cloud.bigtable_admin_v2"
    "google.cloud.bigtable_v2"
    "google.cloud.bigtable"
  ];

  meta = with lib; {
    description = "Google Cloud Bigtable API client library";
    homepage = "https://github.com/googleapis/python-bigtable";
    changelog = "https://github.com/googleapis/python-bigtable/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
