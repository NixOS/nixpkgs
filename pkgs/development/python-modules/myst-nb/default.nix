{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, flit-core
, importlib-metadata
, ipython
, jupyter-cache
, nbclient
, myst-parser
, nbformat
, pyyaml
, sphinx
, sphinx-togglebutton
, typing-extensions
, ipykernel
}:

buildPythonPackage rec {
  pname = "myst-nb";
  version = "0.16.0";

  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9c7ab37929da72f78569a37bcccbc5d49fd679fd7935bf6c9fa36365eb58783a";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    importlib-metadata
    ipython
    jupyter-cache
    nbclient
    myst-parser
    nbformat
    pyyaml
    sphinx
    sphinx-togglebutton
    typing-extensions
    ipykernel
  ];

  pythonImportsCheck = [ "myst_nb" ];

  meta = with lib; {
    description = "A Jupyter Notebook Sphinx reader built on top of the MyST markdown parser";
    homepage = "https://github.com/executablebooks/myst-nb";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
