{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  libcst,
  mock,
  proto-plus,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "google-cloud-iam";
  version = "2.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6TgaGCPlFi9owoBI/xowe6Og5Tja9getfUHP47dWpvA=";
  };

  propagatedBuildInputs = [
    google-api-core
    libcst
    proto-plus
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # unmaintained, reference wrong import path for google.cloud.iam.v1
    "tests/unit/gapic/iam_admin_v1/test_iam.py"
  ];

  pythonImportsCheck = [
    "google.cloud.iam_credentials"
    "google.cloud.iam_credentials_v1"
  ];

  meta = with lib; {
    description = "IAM Service Account Credentials API client library";
    homepage = "https://github.com/googleapis/python-iam";
    changelog = "https://github.com/googleapis/python-iam/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ austinbutler ];
  };
}
