{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  black,
  click,
  docutils,
  itsdangerous,
  jedi,
  markdown,
  psutil,
  pygments,
  pymdown-extensions,
  starlette,
  tomlkit,
  uvicorn,
  websockets,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "marimo";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c+1hiOOWblN0pk+dkIlYm8HqQfHIph0FE5XAQufH86g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    black
    click
    docutils
    itsdangerous
    jedi
    markdown
    psutil
    pygments
    pymdown-extensions
    starlette
    tomlkit
    uvicorn
    websockets
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "marimo" ];

  meta = with lib; {
    description = "Reactive Python notebook that's reproducible, git-friendly, and deployable as scripts or apps";
    homepage = "https://github.com/marimo-team/marimo";
    changelog = "https://github.com/marimo-team/marimo/releases/tag/${version}";
    license = licenses.asl20;
    mainProgram = "marimo";
    maintainers = with maintainers; [
      akshayka
      dmadisetti
    ];
  };
}
