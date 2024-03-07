{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, grpc-google-iam-v1
, libcst
, mock
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "google-cloud-datacatalog";
  version = "3.18.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d4MTAZgseV5iI83A7lSkbe/SEgX9ZfQ0pLHfYBStfp4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    google-api-core
    grpc-google-iam-v1
    libcst
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.datacatalog"
  ];

  meta = with lib; {
    description = "Google Cloud Data Catalog API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-datacatalog";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-datacatalog-v${version}/packages/google-cloud-datacatalog/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
