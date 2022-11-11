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
  version = "0.17.1";

  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FN9yXz4Ay17+9PhjvwwnNJDIxmLf7jntins3S/JWGTM=";
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
    changelog = "https://github.com/executablebooks/MyST-NB/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
