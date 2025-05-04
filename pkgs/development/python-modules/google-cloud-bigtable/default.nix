{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  google-api-core,
  google-cloud-core,
  google-crc32c,
  grpc-google-iam-v1,
  proto-plus,
  protobuf,

  # optional dependencies
  libcst,

  # testing
  grpcio,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "google-cloud-bigtable";
  version = "2.30.1";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-bigtable";
    tag = "v${version}";
    hash = "sha256-TciCYpnwfIIvOexp4Ing6grZ7ufFonwP2G26UzlNaJ4=";
  };

  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-cloud-core
    google-crc32c
    grpc-google-iam-v1
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  optional-dependencies = {
    libcst = [ libcst ];
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

  disabledTests = [ "policy" ];

  pythonImportsCheck = [
    "google.cloud.bigtable_admin_v2"
    "google.cloud.bigtable_v2"
    "google.cloud.bigtable"
  ];

  meta = {
    description = "Google Cloud Bigtable API client library";
    homepage = "https://github.com/googleapis/python-bigtable";
    changelog = "https://github.com/googleapis/python-bigtable/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
