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
  version = "5.7.1";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OBCgEwRT7QMZcFIdIJibilkvPC5zKDqCgK40rh91s/g=";
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

  checkInputs = [
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
