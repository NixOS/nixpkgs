{ lib
, buildPythonPackage
, fetchPypi
, hatch-nodejs-version
, hatchling
, y-py
, pytestCheckHook
, websockets
, ypy-websocket
}:

buildPythonPackage rec {
  pname = "jupyter-ydoc";
  version = "0.3.4";

  format = "pyproject";

  src = fetchPypi {
    pname = "jupyter_ydoc";
    inherit version;
    hash = "sha256-WiJi5wvwBLgsxs5xZ16TMKoFj+MNsuh82BJa1N0a5OE=";
  };

  nativeBuildInputs = [
    hatch-nodejs-version
    hatchling
  ];

  propagatedBuildInputs = [
    y-py
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
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
