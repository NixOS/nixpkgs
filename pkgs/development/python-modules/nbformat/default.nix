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
  version = "5.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b516788ad70771c6250977c1374fcca6edebe6126fd2adb5a69aa5c2356fd1c8";
  };

  LC_ALL="en_US.utf8";

  checkInputs = [ pytest glibcLocales ];
  propagatedBuildInputs = [ ipython_genutils traitlets testpath jsonschema jupyter_core ];

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
