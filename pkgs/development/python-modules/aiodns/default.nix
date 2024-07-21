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
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "saghul";
    repo = "aiodns";
    rev = "refs/tags/v${version}";
    hash = "sha256-aXae9/x0HVp4KqydCf5/+p5PlSKUQ5cE3iVeD08rtf0=";
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
