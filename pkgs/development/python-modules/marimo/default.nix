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
  version = "0.6.14";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9rbRoBshVK0P8eqdOHyKQCwNkPsp2HiIhzyST3QXJpc=";
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
    description = "A reactive Python notebook that's reproducible, git-friendly, and deployable as scripts or apps";
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
