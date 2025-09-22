{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  incremental,
  pythonOlder,
  setuptools,
  typer,
}:

buildPythonPackage rec {
  pname = "ovoenergy";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "ovoenergy";
    tag = version;
    hash = "sha256-7SXnOyvBsBPQ+4tC6pcEXGtcLdqKjzlB2xDZmw/uWcM=";
  };

  postPatch = ''
    substituteInPlace requirements_setup.txt \
      --replace-fail "==" ">="
  '';

  build-system = [
    incremental
    setuptools
  ];

  nativeBuildInputs = [ incremental ];

  dependencies = [
    aiohttp
    click
    typer
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ovoenergy" ];

  meta = with lib; {
    description = "Python client for getting data from OVO's API";
    homepage = "https://github.com/timmo001/ovoenergy";
    changelog = "https://github.com/timmo001/ovoenergy/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
