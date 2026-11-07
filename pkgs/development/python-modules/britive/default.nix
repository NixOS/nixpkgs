{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  jmespath,
}:

buildPythonPackage rec {
  pname = "britive";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "britive";
    repo = "python-sdk";
    tag = "v${version}";
    hash = "sha256-FHKcYcvaO0KTGmTVMcJNzG1Yw8O0a0OBhYZmiYFbo14=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    jmespath
  ];

  # Tests exist but require authentication/credentials to run
  doCheck = false;

  pythonImportsCheck = [ "britive" ];

  meta = {
    description = "A pure Python SDK for the Britive API";
    homepage = "https://github.com/britive/python-sdk";
    changelog = "https://github.com/britive/python-sdk/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matrixman ];
  };
}
