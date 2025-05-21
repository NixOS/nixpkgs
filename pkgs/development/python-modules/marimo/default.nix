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
  version = "0.8.15";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S+lhoyM8s6wLFq1oGJMdzq+s+Uhn76qMgbkMUwpVr44=";
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
