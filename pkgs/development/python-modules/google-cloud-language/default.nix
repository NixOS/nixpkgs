{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-language";
  version = "2.18.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_language";
    inherit version;
    hash = "sha256-dblTX2tCTJwI/h7118zkKTJZGoDac6HacsWR39xpxB4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.language"
    "google.cloud.language_v1"
    "google.cloud.language_v1beta2"
  ];

  meta = with lib; {
    description = "Google Cloud Natural Language API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-language";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-language-v${version}/packages/google-cloud-language/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
