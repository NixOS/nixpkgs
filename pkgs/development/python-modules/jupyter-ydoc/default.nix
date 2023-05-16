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
<<<<<<< HEAD
  version = "1.0.2";
=======
  version = "0.3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  format = "pyproject";

  src = fetchPypi {
    pname = "jupyter_ydoc";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-D5W+3j8eCB4H1cV8A8ZY46Ukfg7xiIkHT776IN0+ylM=";
=======
    hash = "sha256-WiJi5wvwBLgsxs5xZ16TMKoFj+MNsuh82BJa1N0a5OE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = lib.teams.jupyter.members;
=======
    maintainers = with lib.maintainers; [ dotlambda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
