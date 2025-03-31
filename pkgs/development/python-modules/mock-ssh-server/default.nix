{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  paramiko,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mock-ssh-server";
  version = "0.9.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "carletes";
    repo = "mock-ssh-server";
    tag = version;
    hash = "sha256-yJd+WDidW5ouofytAKTlSiZhIQg2cLs8BvEp15qwtjo=";
  };

  build-system = [ setuptools ];

  dependencies = [ paramiko ];

  # Tests are running into a timeout on Hydra, they work locally
  doCheck = false;

  pythonImportsCheck = [ "mockssh" ];

  meta = with lib; {
    description = "Python mock SSH server for testing purposes";
    homepage = "https://github.com/carletes/mock-ssh-server";
    changelog = "https://github.com/carletes/mock-ssh-server/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
