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
  version = "5.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "562de41fc7f4f481b79ab5d683279bf3a168858268d4387b489b7b02be0b324a";
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
