{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  future,
  jsonschema,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pythonRelaxDepsHook,
  requests,
  responses,
  setuptools,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "polyswarm-api";
  version = "3.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "polyswarm";
    repo = "polyswarm-api";
    rev = "refs/tags/${version}";
    hash = "sha256-zEh8qus/+3mcAaY+SK6FLT6wB6UtGLKPoR1WVZdn9vM=";
  };

  pythonRelaxDeps = [ "future" ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  build-system = [ setuptools ];

  dependencies = [
    future
    jsonschema
    python-dateutil
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
    vcrpy
  ];

  pythonImportsCheck = [ "polyswarm_api" ];

  meta = with lib; {
    description = "Library to interface with the PolySwarm consumer APIs";
    homepage = "https://github.com/polyswarm/polyswarm-api";
    changelog = "https://github.com/polyswarm/polyswarm-api/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
