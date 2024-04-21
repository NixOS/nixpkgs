{
  lib,
  azure-identity,
  buildPythonPackage,
  fetchFromGitHub,
  microsoft-kiota-abstractions,
  microsoft-kiota-authentication-azure,
  microsoft-kiota-http,
  microsoft-kiota-serialization-form,
  microsoft-kiota-serialization-json,
  microsoft-kiota-serialization-multipart,
  microsoft-kiota-serialization-text,
  msgraph-core,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "msgraph-sdk";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microsoftgraph";
    repo = "msgraph-sdk-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-UaGdusPGWlF7gTzpCq9WrF/evdDSK5srrkH8/Vz9O8M=";
  };

  build-system = [ setuptools ];

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

  meta = with lib; {
    description = "Microsoft Graph SDK for Python";
    homepage = "https://github.com/microsoftgraph/msgraph-sdk-python";
    changelog = "https://github.com/microsoftgraph/msgraph-sdk-python/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
