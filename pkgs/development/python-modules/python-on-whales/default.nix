{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pydantic,
  requests,
  tqdm,
  typer,
}:

buildPythonPackage rec {
  pname = "python-on-whales";
  version = "0.75.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gabrieldemarmiesse";
    repo = "python-on-whales";
    tag = "v${version}";
    hash = "sha256-JjzBFVgPNnU0q5hL+RZJMs3WxbeZbBKyvsV6clUFjpE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydantic
    requests
    tqdm
    typer
  ];

  doCheck = false; # majority of tests require Docker and/or network access

  pythonImportsCheck = [ "python_on_whales" ];

  meta = {
    description = "Docker client for Python, designed to be fun and intuitive";
    homepage = "https://github.com/gabrieldemarmiesse/python-on-whales";
    changelog = "https://github.com/gabrieldemarmiesse/python-on-whales/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
