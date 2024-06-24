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
  version = "2.13.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Vp01Jgr5Bt4luOKna2Nk4FgJuEU6/Ynac41KT8uQhG8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

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
    maintainers = with maintainers; [ ];
  };
}
