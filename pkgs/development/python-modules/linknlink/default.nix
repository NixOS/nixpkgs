{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "linknlink";
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "xuanxuan000";
    repo = "python-linknlink";
    rev = "refs/tags/${version}";
    hash = "sha256-kV9NCe0u3Z0J9bg1kko5D9fQvyqWTN7v3cVcNQvO0g0=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  pythonImportsCheck = [ "linknlink" ];

  # Module has no test
  doCheck = false;

  meta = with lib; {
    description = "Module and CLI for controlling Linklink devices locally";
    homepage = "https://github.com/xuanxuan000/python-linknlink";
    changelog = "https://github.com/xuanxuan000/python-linknlink/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
