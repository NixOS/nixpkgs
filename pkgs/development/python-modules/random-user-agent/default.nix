{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "random-user-agent";
  version = "1.0.1-unstable-2018-12-26";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Luqman-Ud-Din";
    repo = "random_user_agent";
    rev = "9547a1d93558c5838f734357c695fee92be905f7";
    hash = "sha256-BkMx7N8O9I4rD8lvpoyXTZbZDsoozIpYUQh+zkLQ7Uc=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "random_user_agent" ];

  meta = with lib; {
    description = "Module to get list of user agents based on filters";
    homepage = "https://github.com/Luqman-Ud-Din/random_user_agent";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
