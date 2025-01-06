{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-cloud-core,
  grpcio,
  grpc-google-iam-v1,
  libcst,
  mock,
  proto-plus,
  protobuf,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-bigtable";
  version = "2.27.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_bigtable";
    inherit version;
    hash = "sha256-pqIZgoO9fRHkPD+Ydnqa9DeJs4mvhadhoFsI/dn1e6s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-cloud-core
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

  meta = with lib; {
    description = "Google Cloud Bigtable API client library";
    homepage = "https://github.com/googleapis/python-bigtable";
    changelog = "https://github.com/googleapis/python-bigtable/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
