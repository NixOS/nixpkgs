{ lib
, buildPythonPackage
, fetchPypi
, fastjsonschema
, hatchling
, hatch-nodejs-version
, pytestCheckHook
, glibcLocales
, ipython_genutils
, traitlets
, testpath
, jsonschema
, jupyter_core
, pep440
}:

buildPythonPackage rec {
  pname = "nbformat";
  version = "5.7.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HUdgwVwaBCae9crzdb6LmN0vaW5eueYD7Cvwkfmw0/M=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-nodejs-version
  ];

  LC_ALL="en_US.utf8";

  propagatedBuildInputs = [
    fastjsonschema
    ipython_genutils
    jsonschema
    jupyter_core
    pep440
    testpath
    traitlets
  ];

  checkInputs = [ pytestCheckHook glibcLocales ];

  preCheck = ''
    mkdir tmp
    export HOME=tmp
  '';

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "The Jupyter Notebook format";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh globin ];
  };
}
