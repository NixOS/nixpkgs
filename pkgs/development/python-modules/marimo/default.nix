{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
  click,
  docutils,
  itsdangerous,
  jedi,
  markdown,
  narwhals,
  packaging,
  psutil,
  pygments,
  pymdown-extensions,
  pyyaml,
  ruff,
  starlette,
  tomlkit,
  uvicorn,
  websockets,
}:

let
  pname = "marimo";
  version = "0.9.9";
in
buildPythonPackage {
  inherit pname version;

  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sCN17Q98TWhscNTCItuarrpbs6sMVAZYXwka8pUzq28=";
  };

  nativeBuildInputs = [ hatchling ];

  # ruff is not packaged as a python module in nixpkgs
  pythonRemoveDeps = [ "ruff" ];

  dependencies = [
    click
    docutils
    itsdangerous
    jedi
    markdown
    narwhals
    packaging
    psutil
    pygments
    pymdown-extensions
    pyyaml
    ruff
    starlette
    tomlkit
    uvicorn
    websockets
  ];

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
