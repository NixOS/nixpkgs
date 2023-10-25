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
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "myst-nb";
  version = "0.17.2";

  format = "flit";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D2E4ZRX6sHxzZGrcqX//L2n0HpDTE6JgIXxbvkGdhYs=";
  };

  nativeBuildInputs = [
    flit-core
    pythonRelaxDepsHook
  ];

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

  pythonRelaxDeps = [
    "myst-parser"
  ];

  pythonImportsCheck = [ "myst_nb" ];

  meta = with lib; {
    description = "A Jupyter Notebook Sphinx reader built on top of the MyST markdown parser";
    homepage = "https://github.com/executablebooks/MyST-NB";
    changelog = "https://github.com/executablebooks/MyST-NB/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
