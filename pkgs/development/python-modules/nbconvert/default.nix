{ lib
, buildPythonPackage
, fetchPypi
, pytest
, nose
, glibcLocales
, entrypoints
, bleach
, mistune
, jinja2
, pygments
, traitlets
, testpath
, jupyter_core
, nbformat
, ipykernel
, pandocfilters
, tornado
, jupyter_client
, defusedxml
}:

buildPythonPackage rec {
  pname = "nbconvert";
  version = "5.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "138381baa41d83584459b5cfecfc38c800ccf1f37d9ddd0bd440783346a4c39c";
  };

  checkInputs = [ nose pytest glibcLocales ];

  propagatedBuildInputs = [
    entrypoints bleach mistune jinja2 pygments traitlets testpath
    jupyter_core nbformat ipykernel pandocfilters tornado jupyter_client
    defusedxml
  ];

  # disable preprocessor tests for ipython 7
  # see issue https://github.com/jupyter/nbconvert/issues/898
  checkPhase = ''
    export LC_ALL=en_US.UTF-8
    HOME=$(mktemp -d) py.test -v --ignore="nbconvert/preprocessors/tests/test_execute.py"
  '';

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Converting Jupyter Notebooks";
    homepage = https://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
