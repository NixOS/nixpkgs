{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, black
, click
, docutils
, itsdangerous
, jedi
, markdown
, psutil
, pygments
, pymdown-extensions
, starlette
, tomlkit
, uvicorn
, websockets
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "marimo";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L6ICaaMRrMOr/d8CJGcXxOYCWTVh8ObckW7xNeLRB2Q=";
  };

  build-system = [
    setuptools
  ];

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
