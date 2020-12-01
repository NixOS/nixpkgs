{ lib
, buildPythonPackage
, fetchPypi
, myst-parser
, docutils
, sphinx
, jupyter-sphinx
, jupyter-cache
, ipython
, nbformat
, nbconvert
, ipywidgets
, pyyaml
, sphinx-togglebutton
, importlib-metadata
, pythonOlder
}:

buildPythonPackage rec {
  pname = "myst-nb";
  version = "0.10.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c803da2cf42bc88182ca129b3e7f3b122899fd263a70dc79be06303bc450d12b";
  };

  propagatedBuildInputs = [
    myst-parser
    docutils
    sphinx
    jupyter-sphinx
    jupyter-cache
    ipython
    nbformat
    nbconvert
    ipywidgets
    pyyaml
    sphinx-togglebutton
    importlib-metadata
  ];

  meta = with lib; {
    description = "A Jupyter Notebook Sphinx reader built on top of the MyST markdown parser";
    homepage = https://github.com/executablebooks/myst_nb;
    license = licenses.bsd3;
  };
}