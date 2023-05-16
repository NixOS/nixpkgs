{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, hatchling
, hatch-nodejs-version
, fastjsonschema
, jsonschema
, jupyter-core
, traitlets
, pep440
, pytestCheckHook
, testpath
}:

buildPythonPackage rec {
  pname = "nbformat";
<<<<<<< HEAD
  version = "5.9.1";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-On9S0EBjnL2KOJAhjIsP+5MhFYjFdEbJAJXjK6WIG10=";
=======
  version = "5.7.3";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SwIfyiTTp0e/TmJmlAM9eS1ZRwWCnl41sU7jNp+fZHc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatchling
    hatch-nodejs-version
  ];

  propagatedBuildInputs = [
    fastjsonschema
    jsonschema
    jupyter-core
    traitlets
  ];

  nativeCheckInputs = [
    pep440
    pytestCheckHook
    testpath
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "The Jupyter Notebook format";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh globin ];
  };
}
