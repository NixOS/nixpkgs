{ lib
, buildPythonPackage
, fetchPypi
, fastjsonschema
, flit-core
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
  version = "5.5.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nr4w5sOz5bR9Of8KOJehrPUj0r+vy04tBM23D4pmxQc=";
  };

  nativeBuildInputs = [
    flit-core
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
