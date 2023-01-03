{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, hatchling
, hatch-nodejs-version
, fastjsonschema
, jsonschema
, jupyter_core
, traitlets
, pep440
, pytestCheckHook
, testpath
}:

buildPythonPackage rec {
  pname = "nbformat";
  version = "5.7.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d4760c15c1a04269ef5caf375be8b98dd2f696e5eb9e603ec2bf091f9b0d3f3";
  };

  nativeBuildInputs = [
    hatchling
    hatch-nodejs-version
  ];

  propagatedBuildInputs = [
    fastjsonschema
    jsonschema
    jupyter_core
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
