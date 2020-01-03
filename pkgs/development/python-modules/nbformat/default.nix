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
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7494ef0df60766b7cabe0a3651556345a963b74dbc16bc7c18479041170d402";
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
    homepage = https://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh globin ];
  };
}
