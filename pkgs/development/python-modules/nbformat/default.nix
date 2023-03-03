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
  version = "5.7.3";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SwIfyiTTp0e/TmJmlAM9eS1ZRwWCnl41sU7jNp+fZHc=";
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
