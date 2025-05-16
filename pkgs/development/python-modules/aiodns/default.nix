{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycares,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiodns";
  version = "3.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "saghul";
    repo = "aiodns";
    tag = "v${version}";
    hash = "sha256-y3QuMj2y/V6orM+1+cbUCgj0UL8sXQVzLLYXLnBdlio=";
  };

  build-system = [ setuptools ];

  dependencies = [ pycares ];

  # Could not contact DNS servers
  doCheck = false;

  pythonImportsCheck = [ "aiodns" ];

  meta = with lib; {
    description = "Simple DNS resolver for asyncio";
    homepage = "https://github.com/saghul/aiodns";
    changelog = "https://github.com/saghul/aiodns/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
