{ lib
, buildPythonPackage
, fetchPypi
, fastjsonschema
, pytestCheckHook
, glibcLocales
, ipython_genutils
, traitlets
, testpath
, jsonschema
, jupyter_core
}:

buildPythonPackage rec {
  pname = "nbformat";
  version = "5.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RLpcpqy4DF1aUA8eW4Pt6MvjZNWklcTIz2Cq8bplZQE=";
  };

  LC_ALL="en_US.utf8";

  checkInputs = [ pytestCheckHook glibcLocales ];
  propagatedBuildInputs = [ ipython_genutils traitlets testpath jsonschema jupyter_core fastjsonschema ];

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
