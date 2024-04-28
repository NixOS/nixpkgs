{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, click
, jedi
, markdown
, pymdown-extensions
, pygments
, tomlkit
, uvicorn
, starlette
, websockets
, docutils
, black
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "marimo";
  version = "0.4.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-shB7TIllXRja0RNLu+IyvFBQViee4Ypj5KGWh3AlMB4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    click
    jedi
    markdown
    pymdown-extensions
    pygments
    tomlkit
    uvicorn
    starlette
    websockets
    docutils
    black
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "marimo"
  ];

  meta = with lib; {
    description = "A reactive Python notebook that's reproducible, git-friendly, and deployable as scripts or apps";
    homepage = "https://github.com/marimo-team/marimo";
    changelog = "https://github.com/marimo-team/marimo/releases/tag/${version}";
    license = licenses.asl20;
    mainProgram = "marimo";
    maintainers = with maintainers; [ akshayka dmadisetti ];
  };
}
