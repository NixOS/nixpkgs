{
  lib,
  azure-identity,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  microsoft-kiota-abstractions,
  microsoft-kiota-authentication-azure,
  microsoft-kiota-http,
  microsoft-kiota-serialization-form,
  microsoft-kiota-serialization-json,
  microsoft-kiota-serialization-multipart,
  microsoft-kiota-serialization-text,
  msgraph-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "msgraph-sdk";
  version = "1.54.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoftgraph";
    repo = "msgraph-sdk-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xlUZFw3A9ByXswVGBsxi00n3WvLc4OzCQnIQkTZp21A=";
  };

  build-system = [ flit-core ];

  dependencies = [
    azure-identity
    microsoft-kiota-abstractions
    microsoft-kiota-authentication-azure
    microsoft-kiota-http
    microsoft-kiota-serialization-form
    microsoft-kiota-serialization-json
    microsoft-kiota-serialization-multipart
    microsoft-kiota-serialization-text
    msgraph-core
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "msgraph" ];

  meta = {
    description = "Microsoft Graph SDK for Python";
    homepage = "https://github.com/microsoftgraph/msgraph-sdk-python";
    changelog = "https://github.com/microsoftgraph/msgraph-sdk-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
