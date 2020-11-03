{ lib
, buildPythonPackage
, fetchPypi
, pytest
, glibcLocales
, ipython_genutils
, traitlets
, testpath
, jsonschema
, jupyter_core
}:

buildPythonPackage rec {
  pname = "nbformat";
  version = "5.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f545b22138865bfbcc6b1ffe89ed5a2b8e2dc5d4fe876f2ca60d8e6f702a30f8";
  };

  LC_ALL="en_US.utf8";

  checkInputs = [ pytest glibcLocales ];
  requiredPythonModules = [ ipython_genutils traitlets testpath jsonschema jupyter_core ];

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
