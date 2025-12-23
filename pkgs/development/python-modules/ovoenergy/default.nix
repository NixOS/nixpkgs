{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  incremental,
  setuptools,
  pyjwt,
  typer,
}:

buildPythonPackage rec {
  pname = "ovoenergy";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "ovoenergy";
    tag = version;
    hash = "sha256-oWJxpiC83C/ghs/Ik8+DrPWtP/j5jWEZ3+9Nqg4ARKU=";
  };

  build-system = [
    incremental
    setuptools
  ];

  nativeBuildInputs = [ incremental ];

  dependencies = [
    aiohttp
    click
    pyjwt
    typer
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ovoenergy" ];

  meta = {
    description = "Python client for getting data from OVO's API";
    homepage = "https://github.com/timmo001/ovoenergy";
    changelog = "https://github.com/timmo001/ovoenergy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
