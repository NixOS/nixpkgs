{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pydantic,
}:

buildPythonPackage rec {
  pname = "python-on-whales";
  version = "0.79.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gabrieldemarmiesse";
    repo = "python-on-whales";
    tag = "v${version}";
    hash = "sha256-MvuTItl3OhYybg36Zizt96FqdY0oh0bfqqMd4mssLGA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydantic
  ];

  doCheck = false; # majority of tests require Docker and/or network access

  pythonImportsCheck = [ "python_on_whales" ];

  meta = {
    description = "Docker client for Python, designed to be fun and intuitive";
    homepage = "https://github.com/gabrieldemarmiesse/python-on-whales";
    changelog = "https://github.com/gabrieldemarmiesse/python-on-whales/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
