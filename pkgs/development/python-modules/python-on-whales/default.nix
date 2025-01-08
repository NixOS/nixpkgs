{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  pydantic,
  requests,
  tqdm,
  typer,
}:

buildPythonPackage rec {
  pname = "python-on-whales";
  version = "0.74.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "gabrieldemarmiesse";
    repo = "python-on-whales";
    tag = "v${version}";
    hash = "sha256-Vi6jq71UPTCLsp8j/sxdPu/0QFmBGxYHeyqth7I8ke4=";
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

  meta = with lib; {
    description = "Docker client for Python, designed to be fun and intuitive";
    homepage = "https://github.com/gabrieldemarmiesse/python-on-whales";
    changelog = "https://github.com/gabrieldemarmiesse/python-on-whales/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "python-on-whales";
  };
}
