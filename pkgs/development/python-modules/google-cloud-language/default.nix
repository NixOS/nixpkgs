{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-language";
  version = "2.17.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_language";
    inherit version;
    hash = "sha256-OgXmZvH1uh/lM3UICsVRF8A7OfKm5j9BdetkKomGowQ=";
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
