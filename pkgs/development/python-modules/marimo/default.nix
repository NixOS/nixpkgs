{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  click,
  docutils,
  itsdangerous,
  jedi,
  markdown,
  packaging,
  psutil,
  pygments,
  pymdown-extensions,
  ruff,
  starlette,
  tomlkit,
  uvicorn,
  websockets,
  pyyaml,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "marimo";
  version = "0.7.20";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vkEBHJN7VqJU+diijiTV7JABT5g/5NY2XEXM0turDWU=";
  };

  build-system = [ setuptools ];

  # ruff is not packaged as a python module in nixpkgs
  pythonRemoveDeps = [ "ruff" ];

  dependencies = [
    click
    docutils
    itsdangerous
    jedi
    markdown
    packaging
    psutil
    pygments
    pymdown-extensions
    ruff
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
