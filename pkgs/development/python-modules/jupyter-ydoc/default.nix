{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, hatch-nodejs-version
, hatchling
, importlib-metadata
, pycrdt
, pytestCheckHook
, websockets
, ypy-websocket
}:

buildPythonPackage rec {
  pname = "jupyter-ydoc";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "jupyter_ydoc";
    inherit version;
    hash = "sha256-m7P00yfUdZfZQwNY3z1ZeViZUhyg61DHmcAjbvTcF30=";
  };

  nativeBuildInputs = [
    hatch-nodejs-version
    hatchling
  ];

  propagatedBuildInputs = [
    pycrdt
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  pythonImportsCheck = [ "jupyter_ydoc" ];

  nativeCheckInputs = [
    pytestCheckHook
    websockets
    ypy-websocket
  ];

  # requires a Node.js environment
  doCheck = false;

  meta = {
    changelog = "https://github.com/jupyter-server/jupyter_ydoc/blob/v${version}/CHANGELOG.md";
    description = "Document structures for collaborative editing using Ypy";
    homepage = "https://github.com/jupyter-server/jupyter_ydoc";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.jupyter.members;
  };
}
